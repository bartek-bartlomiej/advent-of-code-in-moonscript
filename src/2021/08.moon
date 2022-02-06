Utils = require("src.utils")

Segments = do
    LIST = "abcdefg"
    SEGMENT_PATTERN = string.format("[%s]", LIST)
    DIGIT_PATTERN = string.format("(%s+)", SEGMENT_PATTERN)
    MAP = { string.sub(LIST, i, i), i - 1 for i = 1, #LIST }

    hash = (segments) ->
        value = 0
        switch type(segments) 
            when "string"
                for segment in segments\gmatch(Segments.SEGMENT_PATTERN)
                    value += (1 << MAP[segment])
            when "table"
                for segment in *segments
                    value += (1 << MAP[segment])
        
        value

    { :SEGMENT_PATTERN, :DIGIT_PATTERN, :MAP, :hash }

Digit = do
    SEGMENTS = {
        "cf",
        "acdeg",
        "acdfg",
        "bcdf",
        "abdfg",
        "abdefg",
        "acf",
        "abcdefg",
        "abcdfg"
    }
    SEGMENTS[0] = "abcefg"
    MAP = { Segments.hash(segements), digit for digit, segements in pairs(SEGMENTS) }

    { :MAP }


class Set
    difference = (a, b) ->
        with Set!
            for key, _ in pairs(a) 
                [key] = not b[key] or nil

    intersection = (a, b) ->
        with Set!
            for key, _ in pairs(a)
                [key] = b[key]

    union = (a, b) ->
        with Set!
            for set in *{ a, b }
                for key, _ in pairs(set)
                    [key] = true
    
    new: (items={}) =>
        for item in *items
            @[item] = true

    get_items: () =>
        [ key for key, _ in pairs(@) ]

    __add: (a, b) -> union(a, b)
    __mul: (a, b) -> intersection(a, b)
    __sub: (a, b) -> difference(a, b)

    @union = union
    @intersection = intersection
    @difference = difference


get_inversed_map = (all_digits) ->
    digit_sets =
        [2]: {}, -- 1
        [3]: {}, -- 7
        [4]: {}, -- 4
        [5]: {}, -- 2, 3, 5
        [6]: {}, -- 0, 9, 6
        [7]: {}  -- 8

    for list in all_digits\gmatch("([abcdefg]+)")
        characters = [ character for character in string.gmatch(list, "[abcdefg]") ]
        table.insert(digit_sets[#list], Set(characters))
    
    one = digit_sets[2][1]
    four = digit_sets[4][1]
    seven = digit_sets[3][1]
    eight = digit_sets[7][1]
    
    s235 = digit_sets[5][1] * digit_sets[5][2] * digit_sets[5][3]
    s096 = digit_sets[6][1] * digit_sets[6][2] * digit_sets[6][3]

    map = {}
    map.a = seven - (seven * one)
    map.d = s235 * four
    map.g = s235 - (map.a + map.d)
    map.b = four - (one + map.d)
    map.f = s096 - (map.b + map.a + map.g)
    map.c = one - map.f
    map.e = eight - (map.a + map.b + map.c + map.d + map.f + map.g)

    with {}
        for key, set in pairs(map)
            items = set\get_items!
            segment = assert(#items == 1 and items[1])
            [segment] = key


parse_input = (input) -> 
    return for line in *input
        coded_digits, output_digits = line\match("(.+) | (.+)")
        inversed_map = get_inversed_map(coded_digits)
    
        output_digits = output_digits\gmatch(Segments.DIGIT_PATTERN)
        for coded_segments in output_digits
            do
                coded_segments = coded_segments\gmatch(Segments.SEGMENT_PATTERN)
                decoded_segments = [ inversed_map[coded_segment] for coded_segment in coded_segments ]
                
                Digit.MAP[Segments.hash(decoded_segments)]


part_one = (data) ->
    FILTER = Set({1, 4, 7, 8})
    count = 0
    for digits in *data
        for digit in *digits
            count += 1 if FILTER[digit]

    count


part_two = (data) ->
    sum = 0
    for digits in *data
        number = 0
        for position, digit in ipairs(digits)
            number += digit * 10 ^ (4 - position)
        sum += number

    math.floor(sum)


parts:
    [1]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_one
        tests: 26
    [2]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_two
        tests: 61229
