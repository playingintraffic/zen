--[[
    This file is part of ZEN (Zero Extra Nonsense), licensed under the MIT License.
    See the LICENSE file in the root directory for full details.

    © 2025 Case @ Playing In Traffic

    Please retain this copyright notice in all copies or substantial portions of the software.
    Thank you for supporting honest development.
]]

--[[
#########################################################
#  ____  _        _ __   _____ _   _  ____   ___ _   _  #
# |  _ \| |      / \\ \ / /_ _| \ | |/ ___| |_ _| \ | | #
# | |_) | |     / _ \\ V / | ||  \| | |  _   | ||  \| | #
# |  __/| |___ / ___ \| |  | || |\  | |_| |  | || |\  | #
# |_|   |_____/_/   \_\_| |___|_| \_|\____| |___|_| \_| #
#  _____ ____      _    _____ _____ ___ ____            #
# |_   _|  _ \    / \  |  ___|  ___|_ _/ ___|           #
#   | | | |_) |  / _ \ | |_  | |_   | | |               #
#   | | |  _ <  / ___ \|  _| |  _|  | | |___            #
#   |_| |_| \_\/_/   \_\_|   |_|   |___\____|           #              
#########################################################
]]

fx_version "cerulean"
games { "gta5" }

name "zen"
version "0.2.0"
description "ZEN - The Zero Extra Nonsense Server Core"
author "PlayingInTraffic"
lua54 "yes"

--- Core
shared_scripts {
    "init.lua",
    "core/lib/*.lua",
    "core/player/events.lua",
    "core/player/api.lua",

    "testing.lua" -- Remove it in production <3
}
server_scripts {
    "core/registry/server.lua",
    "core/player/class.lua"
}

-- Extensions
client_scripts {
    "core/registry/client.lua",
    "extensions/client/*.lua"
}
shared_scripts {
    "extensions/shared/*.lua"
}
server_scripts {
    "extensions/classes/*.lua",
    "extensions/server/*.lua"
}
