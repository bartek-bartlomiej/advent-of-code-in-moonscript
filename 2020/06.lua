local Utils = require("utils")


local Mask = {}

local KEYS = "abcdefghijklmnopqrtsuvwxyz"


function Mask:reset(value)   
    for key in string.gmatch(KEYS, ".") do
        self[key] = value
    end
end


function Mask.new(initial_value)
    local mask = {}
    Mask.reset(mask, initial_value)
    return setmetatable(mask, { __index = Mask })
end


function get_group_answers(line)
    local group = {}

    for answers in string.gmatch(line, "%S+") do
        for answer in string.gmatch(answers, ".") do
            group[answer] = true
        end
    end

    return group
end


function get_group_common_answers(line)
    local group = {}
    Mask.reset(group, true)

    local mask = Mask.new()
    for answers in string.gmatch(line, "%S+") do
        mask:reset(false)

        for answer in string.gmatch(answers, ".") do
            mask[answer] = true
        end

        for key, value in pairs(mask) do
            group[key] = group[key] and value
        end
    end

    return group
end


function count_answers(group)
    local count = 0
    
    for _, value in pairs(group) do
        if value then
            count = count + 1
        end
    end

    return count
end


function sum_answers(groups)
    local sum = 0

    for _, group in pairs(groups) do
        sum = sum + count_answers(group)
    end

    return sum
end


function part_one(input)
    local groups = Utils.parse_input(input, get_group_answers)
    return sum_answers(groups)
end


function part_two(input)
    local groups = Utils.parse_input(input, get_group_common_answers)
    return sum_answers(groups)
end


local PUZZLE = {
    year = 2020,
    day = 6
}

Utils.check(PUZZLE, part_one, 11, Utils.read_groups)
Utils.run(PUZZLE, part_one, Utils.read_groups)

Utils.check(PUZZLE, part_two, 6, Utils.read_groups)
Utils.run(PUZZLE, part_two, Utils.read_groups)
