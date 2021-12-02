local Utils = require("utils")


function count_occurences(str, character)
    local _, count = string.gsub(str, character, character)
    return count
end


function count_valid(input, is_valid)
    local valid_amount = 0

    local pattern = "(%d+)-(%d+) (%a): (%S+)"
    for first, second, character, password in string.gmatch(input, pattern) do
        if is_valid(password, character, tonumber(first), tonumber(second)) then
            valid_amount = valid_amount + 1
        end
    end

    return valid_amount
end


function part_one(input)

    function is_valid(password, character, low, high)
        local count = count_occurences(password, character)
        return low <= count and count <= high 
    end

    return count_valid(input, is_valid)
end


function part_two(input)
    
    function is_valid(password, character, first_position, second_position)
        local first_character = password[first_position]
        local second_character = password[second_position]
    
        if first_character == character then
            return second_character ~= character
        elseif second_character == character then
            return first_character ~= character
        end
    
        return false
    end

    return count_valid(input, is_valid)
end


Utils.enable_string_indexing()

local PUZZLE = {
    year = 2020,
    day = 2
}

Utils.check(PUZZLE, part_one, 2, Utils.read_raw)
Utils.run(PUZZLE, part_one, Utils.read_raw)

Utils.check(PUZZLE, part_two, 1, Utils.read_raw)
Utils.run(PUZZLE, part_two, Utils.read_raw)
