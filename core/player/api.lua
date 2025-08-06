--[[
    This file is part of ZEN (Zero Extra Nonsense), licensed under the MIT License.
    See the LICENSE file in the root directory for full details.

    © 2025 Case @ Playing In Traffic

    Please retain this copyright notice in all copies or substantial portions of the software.
    Thank you for supporting honest development.
]]

if zen.is_server then
    local api = {}

    --- @section Player Registry

    --- Creates and registers a new player.
    --- @param source number: Player server ID
    --- @return Player|nil: The created Player instance
    function api.create_player(source)
        return create_player(source)
    end

    --- Retrieves the Player instance for source.
    --- @param source number: Player server ID
    --- @return Player|nil: The Player instance or nil
    function api.get_player(source)
        return get_player(source)
    end

    --- Removes a Player from the registry.
    --- @param source number: Player server ID
    function api.remove_player(source)
        remove_player(source)
    end

    --- Saves Player data to storage.
    --- @param source number: Player server ID
    --- @return boolean|nil: True if saved successfully
    function api.save_player(source)
        local player = get_player(source)
        if player then
            return player:save()
        end
    end

    --- Unloads a Player instance from memory.
    --- @param source number: Player server ID
    --- @return boolean|nil: True if unloaded successfully
    function api.unload_player(source)
        local player = get_player(source)
        if player then
            return player:unload()
        end
    end

    --- Checks if a Player has fully loaded.
    --- @param source number: Player server ID
    --- @return boolean: True if loaded
    function api.has_player_loaded(source)
        local player = get_player(source)
        return player and player:has_loaded() or false
    end


    --- @section Player Data

    --- Adds a new data category to a Player.
    --- @param source number: Player server ID
    --- @param category string: Category name
    --- @param value any: Value to store
    --- @param replicate boolean?: Replicate to client
    --- @return boolean: True if added successfully
    function api.add_player_data(source, category, value, replicate)
        local player = get_player(source)
        if player then
            return player:add_data(category, value, replicate)
        end
        return false
    end

    --- Retrieves Player data for a category.
    --- @param source number: Player server ID
    --- @param category string?: Category name (optional)
    --- @return any: The data or nil
    function api.get_player_data(source, category)
        local player = get_player(source)
        return player and player:get_data(category) or nil
    end

    --- Checks if Player has a data category.
    --- @param source number: Player server ID
    --- @param category string: Category name
    --- @return boolean: True if exists
    function api.has_player_data(source, category)
        local player = get_player(source)
        return player and player:has_data(category) or false
    end

    --- Updates a Player data category.
    --- @param source number: Player server ID
    --- @param category string: Category name
    --- @param updates table: Data updates
    --- @param sync boolean?: Sync with client
    --- @return boolean: True if updated successfully
    function api.set_player_data(source, category, updates, sync)
        local player = get_player(source)
        if player then
            return player:set_data(category, updates, sync)
        end
        return false
    end

    --- Removes a Player data category.
    --- @param source number: Player server ID
    --- @param category string: Category name
    function api.remove_player_data(source, category)
        local player = get_player(source)
        if player then
            return player:remove_data(category)
        end
    end

    --- Syncs Player data category to client.
    --- @param source number: Player server ID
    --- @param category string?: Category name (optional)
    function api.sync_player_data(source, category)
        local player = get_player(source)
        if player then
            return player:sync_data(category)
        end
    end


    --- @section User Data

    --- Updates user data for Player.
    --- @param source number: Player server ID
    --- @param updates table: Data updates
    --- @return boolean: True if updated successfully
    function api.update_user_data(source, updates)
        local player = get_player(source)
        if player then
            return player:update_user_data(updates)
        end
        return false
    end


    --- @section Player Methods

    --- Adds a method to Player.
    --- @param source number: Player server ID
    --- @param name string: Method name
    --- @param fn fun(self:Player,...):any: Function implementation
    --- @return boolean: True if added successfully
    function api.add_player_method(source, name, fn)
        local player = get_player(source)
        if player then
            return player:add_method(name, fn)
        end
        return false
    end

    --- Removes a method from Player.
    --- @param source number: Player server ID
    --- @param name string: Method name
    function api.remove_player_method(source, name)
        local player = get_player(source)
        if player then
            return player:remove_method(name)
        end
    end

    --- Runs a method on Player.
    --- @param source number: Player server ID
    --- @param name string: Method name
    --- @param ... any: Arguments to pass
    --- @return any: Method return value
    function api.run_player_method(source, name, ...)
        local player = get_player(source)
        if player then
            return player:run_method(name, ...)
        end
    end

    --- Checks if Player has a method.
    --- @param source number: Player server ID
    --- @param name string: Method name
    --- @return boolean: True if exists
    function api.has_player_method(source, name)
        local player = get_player(source)
        return player and player:has_method(name) or false
    end

    --- Retrieves a method function from Player.
    --- @param source number: Player server ID
    --- @param name string: Method name
    --- @return function|nil: The method function
    function api.get_player_method(source, name)
        local player = get_player(source)
        return player and player:get_method(name) or nil
    end


    --- @section Player Extensions

    --- Adds an extension to Player.
    --- @param source number: Player server ID
    --- @param name string: Extension name
    --- @param ext table: Extension table
    --- @return boolean: True if added successfully
    function api.add_player_extension(source, name, ext)
        local player = get_player(source)
        if player then
            return player:add_extension(name, ext)
        end
        return false
    end

    --- Retrieves a Player extension.
    --- @param source number: Player server ID
    --- @param name string: Extension name
    --- @return table|nil: The extension table
    function api.get_player_extension(source, name)
        local player = get_player(source)
        return player and player:get_extension(name) or nil
    end

    --- Checks if Player has a specific extension.
    --- @param source number: Player server ID
    --- @param name string: Extension name
    --- @return boolean: True if exists
    function api.has_player_extension(source, name)
        local player = get_player(source)
        return player and player:has_extension(name) or false
    end

    --- Lists all extensions attached to Player.
    --- @param source number: Player server ID
    --- @return table: List of extensions
    function api.list_player_extensions(source)
        local player = get_player(source)
        return player and player:list_extensions() or {}
    end


    --- @section Debug

    --- Dumps all Player data to log or console.
    --- @param source number: Player server ID
    function api.dump_player_data(source)
        local player = get_player(source)
        if player then
            return player:dump_data()
        end
    end

    exports("api", function() return api end)
end


if not zen.is_server then
    local api = {}

    --- @section Player Data (Client)

    --- Retrieves player data on the client.
    --- @param category string?: Data category
    --- @return table|nil: Data for the category or all data
    function api.get_player_data(category)
        return get_player_data(category)
    end

    --- Checks if player has a specific data category on the client.
    --- @param category string: Data category
    --- @return boolean: True if exists
    function api.has_player_data(category)
        return get_player_data(category) ~= nil
    end

    --- Dumps all player data to log on the client.
    function api.dump_player_data()
        log("debug", translate("player_data_dump", json.encode(get_player_data())))
    end

    exports("api", function() return api end)
end
