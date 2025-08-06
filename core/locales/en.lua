--[[
    This file is part of ZEN (Zero Extra Nonsense), licensed under the MIT License.
    See the LICENSE file in the root directory for full details.

    © 2025 Case @ Playing In Traffic

    Please retain this copyright notice in all copies or substantial portions of the software.
    Thank you for supporting honest development.
]]

--- @module locales.en
--- @description English language covers core and example files.

return {
    --- @section Debug

    player_data_synced = "[SYNC] '%s' = %s",
    player_data_dump = "Player Data Dump: %s",

    --- @section Info 

    player_dropped = "Player dropped: %s",
    example_extension_unloaded = "Example extension unloaded for player %s",

    --- @section Success

    player_loaded = "Player was loaded successfully: %s",
    player_loaded_client = "Client player was loaded successfully: %s {%d}",
    example_method_ran = "Example method ran: %s",

    --- @section Errors

    player_missing = "Player object is missing.",
    source_missing = "Player source is missing",
    user_missing = "GRAFT user account is missing for %d",
    player_add_failed = "Failed to add player on creation for %d",
    missing_method = "Missing method: %s:%s for player %d",
    duplicate_hook_name = "All registered hooks must have a unique name, '%s' is taken.",
    plugin_hook_failed = "Plugin hook '%s' failed: %s",
    player_class_not_found = "Player class not found.",
    player_creation_failed = "Player creation failed for source: {%s}.",
    player_meta_missing = "Player meta is missing on player load.",
}
