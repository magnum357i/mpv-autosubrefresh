--[[

https://github.com/magnum357i/mpv-autosubrefresh

╔════════════════════════════════╗
║       MPV autosubrefresh       ║
║             v1.0.0             ║
╚════════════════════════════════╝

]]

local mp    = require "mp"
local utils = require "mp.utils"

local subInfo = {path = "", edited = 0}

local function getEdited()

    local file = utils.file_info(subInfo.path)

    return file and file.mtime or 0
end

local function updateSubInfo()

    subInfo.path   = ""
    subInfo.edited = 0

    local sid = mp.get_property("sid")

    if sid then

        local path = mp.get_property("current-tracks/sub/external-filename")

        if path then

            subInfo.path   = path
            subInfo.edited = getEdited()
        end
    end
end

local function refreshSub()

    if subInfo.edited > 0 then

        local eTime = getEdited()

        if subInfo.edited ~= eTime then

            mp.commandv("sub-reload")

            subInfo.edited = eTime

            print("Subtitle reloaded")
        end
    end
end

mp.observe_property("sid", "number", function(_, value)

    updateSubInfo()
end)

mp.observe_property("focused", "bool", function(_, val)

    if val then refreshSub() end
end)