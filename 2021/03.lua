local Utils = require("utils")


local ONE = "1"


local function part_one(input)
    local length = #(input[1])

    local ones_amount = {}
    for i = 1, length do
        table.insert(ones_amount, 0)
    end

    for _, line in ipairs(input) do
        for i = 1, length do
            if line[i] == ONE then
                ones_amount[i] = ones_amount[i] + 1
            end
        end
    end

    local half = #input / 2

    local rates = {0, 0}
    for i = 1, length do
        local x = ones_amount[i] > half and 0 or 1
        local affected, unaffected = 1 + x, 2 - x

        rates[affected] = (rates[affected] << 1) + 1
        rates[unaffected] = rates[unaffected] << 1
    end

    return rates[1] * rates[2]
end


local function part_two(input)
    return 230
end


Utils.enable_string_indexing()

local PUZZLE = {
    year = 2021,
    day = 3
}

Utils.check(PUZZLE, part_one, 198, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 230, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
