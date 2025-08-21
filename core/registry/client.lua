--[[
    This file is part of ZEN (Zero Extra Nonsense), licensed under the MIT License.
    See the LICENSE file in the root directory for full details.

    © 2025 Case @ Playing In Traffic

    Please retain this copyright notice in all copies or substantial portions of the software.
    Thank you for supporting honest development.
]]

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