Utils = require("utils")
Utils.enable_string_indexing!

ONE = "1"
ZERO = "0"

parse_input = (input) -> input


part_one = (input) ->
    length = #(input[1])
    set_bits_amount = for _ = 1, length do 0
    
    for line in *input
        for i = 1, length
            set_bits_amount[i] += 1 if line[i] == ONE
    
    half = #input / 2

    rates = { 0, 0 }
    for i = 1, length
        affected = if set_bits_amount[i] > half then 1 else 2 

        rates = [ rate << 1 for rate in *rates ]
        rates[affected] += 1

    rates[1] * rates[2]


part_two = (input) ->    
    get_rating = (numbers, most_common) ->
        get = (t, i, x, y) ->
            return t[1] if #t == 1
            error("Rating not found") if #t == 0 or i > #(t[1])
                
            set_bits_amount = #[ value for value in *t when value[i] == ONE ]
            filter_value = if set_bits_amount >= #t / 2 then x else y
            filtered_numbers = [ value for value in *t when value[i] == filter_value ]
            
            get(filtered_numbers, i + 1, x, y)

        values = if most_common then { ZERO, ONE } else { ONE, ZERO }
        tonumber(get(numbers, 1, table.unpack(values)), 2)
 
    oxygen_generator_rating = get_rating(input, true)
    carbon_dioxide_scrubber_rating = get_rating(input, false)

    oxygen_generator_rating * carbon_dioxide_scrubber_rating


Utils.run
    number:
        year: 2021, 
        day: 3
    parts:
        [1]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_one
            tests: 198
        [2]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_two
            tests: 230
