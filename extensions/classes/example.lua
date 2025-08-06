--[[
    This file is part of ZEN (Zero Extra Nonsense), licensed under the MIT License.
    See the LICENSE file in the root directory for full details.

    © 2025 Case @ Playing In Traffic

    Please retain this copyright notice in all copies or substantial portions of the software.
    Thank you for supporting honest development.
]]

--- @class Example
--- @description Example player extension for the ZEN system.

--- Define the extension table
local Example = {}

--- Called when the extension is loaded onto the player.
--- Runs when the player object is created, as long as the hook for this extension is registered.
function Example:on_load()
    local player = self.player

    --- Add replicated data to player
    --- Stores a new data category ("example") in the player object and replicates to the client.
    player:add_data("example", { 
        message = "Extension loaded" 
    }, true)

    --- Add a method to player
    --- Injects a callable function "say_hello" into the player object.
    player:add_method("say_hello", function(p, name)
        local msg = ("Hello, %s! This is %s."):format(name or "stranger", p.username)

        --- Logs output using the cores log + translation functions.
        --- @see log & translate: core/lib/utils.lua
        log("info", translate("example_method_output", msg))
        return msg
    end)

    --- Call the method immediately (this is just for demonstration, only do this if you need to)
    --- Executes the newly added "say_hello" method with the current player name.
    local response = player:run_method("say_hello", GetPlayerName(player.source))
    log("success", translate("example_method_ran", response))
end

--- Called when the extension saves player data.
--- Triggered when the player object runs a save cycle (manual or periodic).
function Example:on_save()
    local player = self.player

    log("info", translate("example_extension_saved", player.source))
end

--- Called when the extension is unloaded from the player.
--- Triggered on player disconnect or extension removal to clean up.
function Example:on_unload()
    local player = self.player
    log("info", translate("example_extension_unloaded", player.source))
    
    --- Removes the "say_hello" method from the player object.
    player:remove_method("say_hello")
end

--- Register the hook to attach the extension to players.
--- Registers the extension under the name "example" to attach on player creation.
register_hook("example", function(player)
    --- Clone the extension table and attach player reference
    --- Creates an instance of this extension with a reference to the specific player.
    local instance = setmetatable({ player = player }, { __index = Example })
    player:add_extension("example", instance)
end, 100) --- Loads before other extensions priority 1-100 (good for core or dependency extensions).

