--[[
    This file is part of ZEN (Zero Extra Nonsense), licensed under the MIT License.
    See the LICENSE file in the root directory for full details.

    © 2025 Case @ Playing In Traffic

    Please retain this copyright notice in all copies or substantial portions of the software.
    Thank you for supporting honest development.
]]

--- @section Test Commands

if zen.is_server then
    local test_api = exports.zen:api()

    RegisterCommand("zen:createplayer", function(source, args, raw)
        local player = test_api.create_player(source)
        if player then
            log("success", translate("example_player_created", source))
        else
            log("error", translate("example_player_create_failed", source))
        end
    end)

    RegisterCommand("zen:getplayer", function(source, args, raw)
        local example_data = test_api.get_player_data(source, "example")
        if example_data then
            log("info", translate("example_player_found", source))
            print(json.encode(example_data))
        else
            log("warn", translate("example_player_not_found", source))
        end
    end)

    RegisterCommand("zen:saveplayer", function(source, args, raw)
        if test_api.save_player(source) then
            log("success", translate("example_player_saved", source))
        else
            log("error", translate("example_player_save_failed", source))
        end
    end)

    RegisterCommand("zen:unloadplayer", function(source, args, raw)
        if test_api.unload_player(source) then
            log("success", translate("example_player_unloaded", source))
        else
            log("error", translate("example_player_unload_failed", source))
        end
    end)

    RegisterCommand("zen:hasloaded", function(source, args, raw)
        if test_api.has_player_loaded(source) then
            log("info", translate("example_player_loaded_true", source))
        else
            log("info", translate("example_player_loaded_false", source))
        end
    end)
end

if not zen.is_server then
    local test_api = exports.zen:api()

    RegisterCommand("zen:checkdata", function(_, args)
        local category = args[1] or nil

        if category then
            if test_api.has_player_data(category) then
                log("success", translate("example_client_data_found", category))
                print(json.encode(test_api.get_player_data(category)))
            else
                log("warn", translate("example_client_data_missing", category))
            end
        else
            log("info", translate("example_client_data_dump"))
            test_api.dump_player_data()
        end
    end)
end
