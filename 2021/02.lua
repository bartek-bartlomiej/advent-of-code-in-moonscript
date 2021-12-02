local Utils = require("utils")

local match = string.match
local floor = math.floor

local ACTION_FORWARD = "forward"
local ACTION_UP = "up"
local ACTION_DOWN = "down"


function parse_line(line)
    local pattern = "(%S+) (%d+)"
    return match(line, pattern)
end


function part_one(input)
    local horizontal_position = 0
    local depth = 0

    for _, line in ipairs(input) do
        local action, value = parse_line(line)

        if action == ACTION_FORWARD then
            horizontal_position = horizontal_position + value
        elseif action == ACTION_DOWN then
            depth = depth + value
        elseif action == ACTION_UP then
            depth = depth - value
        else
            assert("Unknown action")
        end
    end

    horizontal_position = floor(horizontal_position)
    depth = floor(depth)

    -- print(horizontal_position .. " x " .. depth)
    return horizontal_position * depth
end


function part_two(input)
    local HORIZONTAL = "horizontal"
    local DEPTH = "depth"
    local AIM = "aim"

    local position = {}
    position[HORIZONTAL] = 0
    position[DEPTH] = 0
    position[AIM] = 0

    function change(key, value)
        position[key] = position[key] + value
    end

    local callbacks = {}
    callbacks[ACTION_DOWN] = function (v) change(AIM, v) end
    callbacks[ACTION_UP] = function (v) change(AIM, -v) end
    callbacks[ACTION_FORWARD] = function (v) 
        change(HORIZONTAL, v)
        change(DEPTH, position[AIM] * v)
    end
    
    for _, line in ipairs(input) do
        local action, value = parse_line(line)
        callbacks[action](value)
    end

    position[HORIZONTAL] = floor(position[HORIZONTAL])
    position[DEPTH] = floor(position[DEPTH])
    position[AIM] = floor(position[AIM])

    -- print(position[HORIZONTAL] .. " x " .. position[DEPTH])
    return position[HORIZONTAL] * position[DEPTH]
end


local PUZZLE = {
    year = 2021,
    day = 2
}

Utils.check(PUZZLE, part_one, 150, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 900, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
