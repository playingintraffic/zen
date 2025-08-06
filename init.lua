--[[
    This file is part of ZEN (Zero Extra Nonsense), licensed under the MIT License.
    See the LICENSE file in the root directory for full details.

    © 2025 Case @ Playing In Traffic

    Please retain this copyright notice in all copies or substantial portions of the software.
    Thank you for supporting honest development.
]]

--- @script init
--- @description Main initilization file.

zen = setmetatable({}, { __index = _G })

--- @section General

zen.resource_name = GetCurrentResourceName()
zen.is_server = IsDuplicityVersion()
zen.version = GetResourceMetadata(zen.resource_name, "version", 0) or "unknown"
zen.debug_mode = GetConvar("zen:debug_mode", "false") == "true"

--- @section Locale

zen.language = GetConvar("zen:language", "en")
zen.locale = exports.graft:get("core.locales." .. zen.language, true) or {}

--- @section Namespace Protection

--- Applies namespace protection to prevent accidental overrides.
setmetatable(zen, {
    __newindex = function(_, key)
        error(("Attempted to assign to zen.%s after initialization"):format(key), 2)
    end
})