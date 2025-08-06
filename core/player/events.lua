--[[
    This file is part of ZEN (Zero Extra Nonsense), licensed under the MIT License.
    See the LICENSE file in the root directory for full details.

    © 2025 Case @ Playing In Traffic

    Please retain this copyright notice in all copies or substantial portions of the software.
    Thank you for supporting honest development.
]]

if IsDuplicityVersion() then

    --- Fired at end of player creation cycle.
    --- Hook externally to react when player is fully loaded.
    --- @param player table: Player object with public properties
    AddEventHandler("zen:sv:player_loaded", function(player)
        if not player then log("error", "player_missing") return end

        local src = player.source
        local meta = {
            source = src,
            unique_id = player.unique_id,
            username = player.username,
            rank = player.rank,
            vip = player.vip,
            priority = player.priority,
            character_slots = player.character_slots
        }

        log("info", translate("player_loaded", src))
        TriggerClientEvent("zen:cl:player_loaded", src, meta)
    end)

    --- Kicks the player who triggered this event.
    RegisterServerEvent("zen:sv:disconnect")
    AddEventHandler("zen:sv:disconnect", function()
        local _src = source
        DropPlayer(_src, translate("player_dropped"))
    end)

end

if not IsDuplicityVersion() then

    --- Fired when player finishes loading on server.
    --- @param meta table: Player metadata sent from server
    RegisterNetEvent("zen:cl:player_loaded")
    AddEventHandler("zen:cl:player_loaded", function(meta)
        if type(meta) ~= "table" or not meta.source then log("error", "player_meta_missing") return end

        log("info", translate("player_loaded_client", meta.username, meta.source))
    end)

end
