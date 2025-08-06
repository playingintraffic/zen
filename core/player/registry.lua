--[[
    This file is part of ZEN (Zero Extra Nonsense), licensed under the MIT License.
    See the LICENSE file in the root directory for full details.

    © 2025 Case @ Playing In Traffic

    Please retain this copyright notice in all copies or substantial portions of the software.
    Thank you for supporting honest development.
]]

if zen.is_server then

    local players = {}
    local hooks = {}
    local executed_hooks = {}

    --- @section Hook Registry

    --- Registers a plugin hook to extend player logic.
    --- @param name string: Unique plugin name
    --- @param fn fun(player:Player):void: Function to call with player as argument
    --- @param priority number|nil: Optional priority (lower loads first, default = 100)
    function register_hook(name, fn, priority)
        if not name or type(fn) ~= "function" then return end
        for _, h in ipairs(hooks) do 
            if h.name == name then 
                return log("error", translate("duplicate_hook_name", name)) 
            end 
        end
        table.insert(hooks, { name = name, fn = fn, priority = priority or 100 })
    end

    --- Executes all registered plugin hooks for the player.
    --- @param player Player: Player instance
    function run_hooks(player)
        table.sort(hooks, function(a, b) return a.priority < b.priority end)
        for _, hook in ipairs(hooks) do
            local ok, err = pcall(hook.fn, player)
            if not ok then
                log("error", translate("plugin_hook_failed", hook.name, err))
            else
                executed_hooks[hook.name] = true
            end
        end
    end

    --- Checks if a plugin hook has executed.
    --- @param name string: Plugin name
    --- @return boolean: True if executed
    function has_hook_run(name)
        return executed_hooks[name] == true
    end

    --- Clears all plugin hooks and their execution state.
    function clear_hooks()
        hooks = {}
        executed_hooks = {}
    end

    --- @section Player Registry

    --- Creates and stores a new player instance.
    --- @param source number: Player source ID
    --- @return Player|nil: Player instance or nil if creation fails
    function create_player(source)
        local exists = get_player(source)
        if exists then return end

        local new_player = Player.new(source)
        if not new_player then log("error", translate("player_creation_failed", source)) return nil end

        run_hooks(new_player)
        new_player:load()

        if players[source] == nil then players[source] = new_player end
        
        TriggerEvent("zen:sv:player_loaded", new_player)

        return new_player
    end

    --- Gets the active player object for a source.
    --- @param source number: Player source ID
    --- @return Player|nil: Player instance or nil if not found
    function get_player(source)
        return players[source]
    end

    --- Removes and unloads a player object from the registry.
    --- @param source number: Player source ID
    function remove_player(source)
        local player = players[source]
        if player then
            players[source] = nil
        end
    end

    --- Saves all players by calling `:save()` on each.
    function save_all_players()
        for _, player in pairs(players) do
            if player.save then player:save() end
        end
    end

    --- @section Event Handlers

    --- Called automatically when a player disconnects.
    --- Saves and unloads the player, then removes them from the registry.
    --- @param reason string: Reason for disconnect
    AddEventHandler("playerDropped", function(reason)
        local _src = source
        local player = get_player(_src)
        if player then
            player:save()
            player:unload()
            remove_player(_src)
            log("info", translate("player_dropped", _src))
        end
    end)

    --- Called when the resource is stopped.
    --- Ensures all player data is saved before shutdown.
    --- @param res string: Name of the resource being stopped
    AddEventHandler("onResourceStop", function(res)
        if res ~= GetCurrentResourceName() then return end
        save_all_players()
    end)

end

if not zen.is_server then

    -- Internal client-side player data cache
    local player_data = {}

    --- Returns a single data category or all data.
    --- @param category string|nil: Data category key (optional)
    --- @return table|nil: Category table or all data
    function get_player_data(category)
        return (category and player_data[category]) or player_data
    end

    --- Sync handler from server.
    --- Updates the local player data cache with replicated values.
    --- @param payload table: Key-value data sent from the server
    RegisterNetEvent("zen:cl:sync_data", function(payload)
        if type(payload) ~= "table" then return end

        for category, data in pairs(payload) do
            if type(category) == "string" and type(data) == "table" then
                player_data[category] = data
                log("debug", translate("player_data_synced", category, json.encode(data)))
            end
        end
    end)

end
