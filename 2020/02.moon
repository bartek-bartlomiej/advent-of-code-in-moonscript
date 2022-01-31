Utils = require("utils")
Utils.enable_string_indexing!


PATTERN = "(%d+)-(%d+) (%a): (%S+)"

parse_input = (input) -> 
    return for first, second, character, password in input\gmatch(PATTERN) 
        policy = {
            :character
            first: tonumber(first)
            second: tonumber(second) 
        }

        { password, policy } 


count_valid = (data, is_valid) ->
    unpack = table.unpack

    valid_amount = 0
    for case in *data
        valid_amount += 1 if is_valid(unpack(case))
    
    valid_amount


count_occurences = (str, character) ->
    _, count = string.gsub(str, character, character)
    
    count


part_one = (data) ->
    is_valid = (password, policy) ->
        { :character, first: lowest, second: highest } = policy

        count = count_occurences(password, character)

        lowest <= count and count <= highest

    count_valid(data, is_valid)


part_two = (data) ->
    is_valid = (password, policy) ->
        { :character, first: first_position, second: second_position } = policy

        first_character = password[first_position]
        second_character = password[second_position]

        if first_character == character
            return second_character ~= character
        elseif second_character == character
            return first_character ~= character
        
        false

    count_valid(data, is_valid)


Utils.run
    number:
        year: 2020, 
        day: 2
    parts:
        [1]:
            read: Utils.read_raw
            parse: parse_input
            solution: part_one
            tests: 2
        [2]:
            read: Utils.read_raw
            parse: parse_input
            solution: part_two
            tests: 1
