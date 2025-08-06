--[[
    This file is part of ZEN (Zero Extra Nonsense), licensed under the MIT License.
    See the LICENSE file in the root directory for full details.

    © 2025 Case @ Playing In Traffic

    Please retain this copyright notice in all copies or substantial portions of the software.
    Thank you for supporting honest development.
]]

--- @class Player
--- @description Main player class realistically this should not need touching only extended via your extension classes.

Player = {}
Player.__index = Player
Player.__metatable = false

--- Weak-keyed private internal state
local Private = setmetatable({}, { __mode = "k" })

--- Creates a new player instance.
--- @param source number: Player source ID
--- @return Player|nil: New Player instance or nil if creation fails
function Player.new(source)
    if not source then log("error", translate("source_missing")) return nil end

    local user = exports.graft:get_user(source)
    if not user then log("error", translate("user_missing", source)) return nil end

    local self = setmetatable({
        source = source,
        unique_id = user.unique_id,
        username = user.username or ("default_" .. user.unique_id),
        rank = user.rank,
        vip = user.vip,
        priority = user.priority,
        character_slots = user.characters
    }, Player)

    Private[self] = {
        user = user,
        data = {
            user = {
                unique_id = user.unique_id,
                rank = user.rank,
                username = user.username,
                priority = user.priority,
                character_slots = user.character_slots
            }
        },
        replicated = {},
        extensions = {},
        methods = {},
        loaded = false
    }

    return self
end

--- Loads all extensions and syncs initial data.
--- @return boolean: True if loaded
function Player:load()
    local priv = Private[self]
    if not priv then return false end
    
    for _, ext in pairs(priv.extensions) do if ext.on_load then ext:on_load() end end
    
    self:sync_data()
    priv.loaded = true
    log("success", translate("player_loaded", self.unique_id))
    return true
end

--- Saves the player state by calling all extension save handlers.
--- @return boolean: True if saved
function Player:save()
    local priv = Private[self]
    if not priv then return false end
    
    for _, ext in pairs(priv.extensions) do if ext.on_save then ext:on_save() end end
    
    TriggerEvent("zen:sv:player_save", self)
    return true
end

--- Unloads the player, fires unload hooks, and removes from registry.
--- @return boolean: True on completion
function Player:unload()
    local priv = Private[self]
     if not priv then return false end

    for _, ext in pairs(priv.extensions) do if ext.on_unload then ext:on_unload() end end
    
    TriggerEvent("zen:sv:player_unload", self)
    remove_player(self.source)
    return true
end

--- Checks if the player has finished loading.
--- @return boolean: True if has finishing loading
function Player:has_loaded()
    return Private[self].loaded
end

--- Adds a data category to the player.
--- @param category string: Data category key
--- @param value any: Value to store in category
--- @param replicate boolean|nil: Whether to replicate to client
--- @return boolean: True if added
function Player:add_data(category, value, replicate)
    if type(category) ~= "string" then return false end
    local priv = Private[self]
    priv.data[category] = value
    if replicate then priv.replicated[category] = true end
    return true
end

--- Retrieves data from a category or the full data table.
--- @param category string|nil: Data category key (optional)
--- @return any: Data for category or full data table
function Player:get_data(category)
    local data = Private[self].data
    return category and data[category] or data
end

--- Checks if a data category exists.
--- @param category string: Data category key
--- @return boolean: True if exists
function Player:has_data(category)
    return Private[self].data[category] ~= nil
end

--- Updates keys inside a data category.
--- @param category string: Data category key
--- @param updates table: Key-value pairs to update
--- @param sync boolean|nil: Whether to sync to client
--- @return boolean: True if update successful
function Player:set_data(category, updates, sync)
    local priv = Private[self]
    local target = priv.data[category]
    if type(target) ~= "table" or type(updates) ~= "table" then return false end
    for k, v in pairs(updates) do target[k] = v end
    if sync then self:sync_data(category) end
    return true
end

--- Removes a data category and syncs if needed.
--- @param category string: Data category key
--- @return boolean: True if removed successfully, false if category doesn't exist
function Player:remove_data(category)
    local priv = Private[self]
    if priv.data[category] ~= nil then
        priv.data[category] = nil
        self:sync_data(category)
        return true
    end
    return false
end

--- Syncs a single or all replicated data categories to the client.
--- @param category string|nil: Data category key (optional, syncs all replicated if nil)
function Player:sync_data(category)
    local priv = Private[self]
    local payload = {}

    if category then
        if not priv.replicated[category] or type(priv.data[category]) ~= "table" then return end
        payload[category] = priv.data[category]
    else
        for k in pairs(priv.replicated) do
            payload[k] = priv.data[k]
        end
    end

    TriggerClientEvent("zen:cl:sync_data", self.source, payload)
end

--- Updates internal user data and propagates to Graft.
--- @param updates table: Key-value pairs to update
--- @return boolean: True if updated successfully
function Player:update_user_data(updates)
    local priv = Private[self]
    if not priv.data.user or type(updates) ~= "table" then return false end

    for k, v in pairs(updates) do
        if priv.data.user[k] ~= nil then
            priv.data.user[k] = v
        end
    end

    exports.graft:update_user_data(self.source, updates)
    return true
end

--- Adds a callable dynamic method to the player.
--- @param name string: Method name
--- @param fn fun(self:Player,...):any: Function implementation
--- @return boolean: True if added successfully, false otherwise
function Player:add_method(name, fn)
    if type(name) == "string" and type(fn) == "function" then
        Private[self].methods[name] = fn
        return true
    end
    return false
end

--- Removes a dynamic method by name.
--- @param name string: Method name
--- @return boolean: True if removed, false if not found
function Player:remove_method(name)
    local methods = Private[self].methods
    if methods[name] then
        methods[name] = nil
        return true
    end
    return false
end

--- Runs a registered dynamic method.
--- @param name string: Method name
--- @param ... any: Arguments for the method
--- @return any: Return value from the method
function Player:run_method(name, ...)
    local fn = Private[self].methods[name]
    return fn and fn(self, ...) or nil
end

--- Checks if a method exists.
--- @param name string: Method name
--- @return boolean: True if exists
function Player:has_method(name)
    return Private[self].methods[name] ~= nil
end

--- Gets a dynamic method by name.
--- @param name string: Method name
--- @return function|nil: Method function or nil
function Player:get_method(name)
    return Private[self].methods[name]
end

--- Adds an extension to the player.
--- @param name string: Extension name
--- @param ext table: Extension table
--- @return boolean: True if added successfully, false otherwise
function Player:add_extension(name, ext)
    if type(name) == "string" and type(ext) == "table" then
        Private[self].extensions[name] = ext
        return true
    end
    return false
end

--- Removes an extension by name.
--- @param name string: Extension name
--- @return boolean: True if removed, false if not found
function Player:remove_extension(name)
    local extensions = Private[self].extensions
    if extensions[name] then
        extensions[name] = nil
        return true
    end
    return false
end

--- Gets an extension by name.
--- @param name string: Extension name
--- @return table|nil: Extension table or nil
function Player:get_extension(name)
    return Private[self].extensions[name]
end

--- Checks if the player has a specific extension.
--- @param name string: Extension name
--- @return boolean: True if exists
function Player:has_extension(name)
    return Private[self].extensions[name] ~= nil
end

--- Lists all registered extensions.
--- @return string[]: Array of extension names
function Player:list_extensions()
    local keys = {}
    for k in pairs(Private[self].extensions) do keys[#keys + 1] = k end
    return keys
end

--- Logs a debug dump of all player data.
function Player:dump_data()
    log("debug", translate("player_data_dump", json.encode(Private[self].data)))
end
