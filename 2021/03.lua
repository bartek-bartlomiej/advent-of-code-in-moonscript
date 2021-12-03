local Utils = require("utils")


local ONE = "1"
local ZERO = "0"


local function part_one(input)
    local length = #(input[1])

    local set_bits_amount = {}
    for i = 1, length do
        table.insert(set_bits_amount, 0)
    end

    for _, line in ipairs(input) do
        for i = 1, length do
            if line[i] == ONE then
                set_bits_amount[i] = set_bits_amount[i] + 1
            end
        end
    end

    local half = #input / 2

    local rates = {0, 0}
    for i = 1, length do
        local x = set_bits_amount[i] > half and 0 or 1
        local affected, unaffected = 1 + x, 2 - x

        rates[affected] = (rates[affected] << 1) + 1
        rates[unaffected] = rates[unaffected] << 1
    end

    return rates[1] * rates[2]
end


local function part_two(input)

    local function count(t, condition)
        local result = 0
        for _, value in ipairs(t) do
            if condition(value) then
                result = result + 1
            end
        end

        return result
    end

    local function filter(t, condition)
        local result = {}
        for _, value in ipairs(t) do
            if condition(value) then
                table.insert(result, value)
            end
        end

        return result
    end

    local function get_rating(numbers, most_common)
        local function get(t, i, x, y)
            if #t == 1 then
                return t[1]
            end

            if #t == 0 or i > #(t[1]) then
                error("Rating not found")
            end

            local set_bits_amount = count(t, function (v) return v[i] == ONE end)
            local filter_value = set_bits_amount >= #t / 2 and x or y
            local filtered_numbers = filter(t, function (v) return v[i] == filter_value end)
            return get(filtered_numbers, i + 1, x, y)
        end

        local values = most_common and { ZERO, ONE } or { ONE, ZERO }
        return tonumber(get(numbers, 1, table.unpack(values)), 2)
    end

    local oxygen_generator_rating = get_rating(input, true)
    local CO2_scrubber_rating = get_rating(input, false)

    return oxygen_generator_rating * CO2_scrubber_rating
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
