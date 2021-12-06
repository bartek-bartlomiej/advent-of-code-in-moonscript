---@diagnostic disable: unused-function
local Utils = require("utils")

local BIRTH = 7
local CHILDHOOD = 2


local function naive_attempt(input, days)
    local function parse_input(raw_input)
        local school = {}
        for fish_input in string.gmatch(raw_input, "(%d)") do
            table.insert(school, tonumber(fish_input) + 1)
        end

        return school
    end

    local function grow(school)
        for _ = 1, days do
            local size = #school
            for i = 1, size do
                local fish = school[i] - 1
                if fish == 0 then
                    school[i] = BIRTH
                    table.insert(school, BIRTH + CHILDHOOD)
                else
                    school[i] = fish
                end
            end
        end
    end

    local school = parse_input(input)
    grow(school)

    return #school
end


local SchoolEpoch = {}
SchoolEpoch._mt = { __index = SchoolEpoch }


function SchoolEpoch:grow()
    local next = SchoolEpoch.new()

    for i = BIRTH + CHILDHOOD, 2, -1 do
        next[i - 1] = self[i]
    end

    local parents = self[1]
    next[BIRTH + CHILDHOOD] = parents
    next[BIRTH] = next[BIRTH] + parents

    return next
end


function SchoolEpoch:sum()
    local result = 0
    for _, amount in ipairs(self) do
        result = result + amount
    end

    return result
end


function SchoolEpoch.new()
    local school = {}
    for i = 1, BIRTH + CHILDHOOD do
        table.insert(school, 0)
    end

    return setmetatable(school, SchoolEpoch._mt)
end


local function better_attempt(input, days)
    local function parse_input(raw_input)
        local first = SchoolEpoch.new()

        for fish_input in string.gmatch(raw_input, "(%d)") do
            local fish = tonumber(fish_input) + 1
            first[fish] = first[fish] + 1
        end

        return first
    end

    local function simulate(epoch, days)
        if days == 0 then return epoch end
        return simulate(epoch:grow(), days - 1)
    end

    local last = simulate(parse_input(input), days)
    return last:sum()
end


local function part_one(input)
    return better_attempt(input, 80)
end


local function part_two(input)
    return better_attempt(input, 256)
end


local PUZZLE = {
    year = 2021,
    day = 6
}

Utils.check(PUZZLE, part_one, 5934, Utils.read_raw)
Utils.run(PUZZLE, part_one, Utils.read_raw)

Utils.check(PUZZLE, part_two, 26984457539, Utils.read_raw)
Utils.run(PUZZLE, part_two, Utils.read_raw)
