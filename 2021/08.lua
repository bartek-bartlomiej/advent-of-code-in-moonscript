local Utils = require("utils")


local Segments = {}

Segments.LIST = "abcdefg"
Segments.SEGMENT_PATTERN = string.format("[%s]", Segments.LIST)
Segments.DIGIT_PATTERN = string.format("(%s+)", Segments.SEGMENT_PATTERN)

Segments.MAP = {}
for i = 1, #(Segments.LIST) do
    local segment = string.sub(Segments.LIST, i, i)
    Segments.MAP[segment] = i - 1
end


function Segments.hash(segments)
    local value = 0
    local map = Segments.MAP
    for segment in string.gmatch(segments, Segments.SEGMENT_PATTERN) do
        value = value + (1 << map[segment])
    end

    return value
end


local Digit = {}

Digit.SEGMENTS = {
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
Digit.SEGMENTS[0] = "abcefg"

Digit.MAP = {}
for digit, segements in pairs(Digit.SEGMENTS) do
    Digit.MAP[Segments.hash(segements)] = digit
end


local Set = {}

function Set.difference(a, b)
    local set = Set.new({})
    for key, _ in pairs(a) do
        set[key] = not b[key] or nil
    end

    return set
end


function Set.intersection(a, b)
    local set = Set.new({})
    for key, _ in pairs(a) do
        set[key] = b[key]
    end

    return set
end


function Set.union(a, b)
    local set = Set.new({})
    for key, _ in pairs(a) do set[key] = true end
    for key, _ in pairs(b) do set[key] = true end

    return set
end


function Set:get_items()
    local t = {}
    for key, _ in pairs(self) do
        table.insert(t, key)
    end

    return t
end


Set._mt = {
    __index = Set,
    __mul = Set.intersection,
    __add = Set.union,
    __sub = Set.difference
}

function Set.new(items)
    local self = {}
    for _, item in ipairs(items) do
        self[item] = true
    end

    return setmetatable(self, Set._mt)
end


local function get_inversed_map(all_digits)
    local digit_sets = {
        [2] = {}, -- 1
        [3] = {}, -- 7
        [4] = {}, -- 4
        [5] = {}, -- 2, 3, 5
        [6] = {}, -- 0, 9, 6
        [7] = {}, -- 8
    }

    for list in string.gmatch(all_digits, "([abcdefg]+)") do
        local characters = {}
        for character in string.gmatch(list, "[abcdefg]") do
            table.insert(characters, character)
        end

        table.insert(digit_sets[#list], Set.new(characters))
    end

    local one = digit_sets[2][1]
    local four = digit_sets[4][1]
    local seven = digit_sets[3][1]
    local eight = digit_sets[7][1]

    local s235 = digit_sets[5][1] * digit_sets[5][2] * digit_sets[5][3]
    local s096 = digit_sets[6][1] * digit_sets[6][2] * digit_sets[6][3]

    local map = {}
    map.a = seven - (seven * one)
    map.d = s235 * four
    map.g = s235 - (map.a + map.d)
    map.b = four - (one + map.d)
    map.f = s096 - (map.b + map.a + map.g)
    map.c = one - map.f
    map.e = eight - (map.a + map.b + map.c + map.d + map.f + map.g)

    local inversed_map = {}
    for key, set in pairs(map) do
        local items = set:get_items()
        assert(#items == 1)

        local segment = items[1]
        inversed_map[segment] = key
    end

    return inversed_map
end


local function decode(line)
    local coded_digits, output_digits = string.match(line, "(.+) | (.+)")

    local inversed_map = get_inversed_map(coded_digits)

    local decoded_output_digits = {}
    for coded_segments in string.gmatch(output_digits, Segments.DIGIT_PATTERN) do
        local decoded_segments = ""
        for coded_segment in string.gmatch(coded_segments, Segments.SEGMENT_PATTERN) do
            decoded_segments = decoded_segments .. inversed_map[coded_segment]
        end

        local decoded_digit = Digit.MAP[Segments.hash(decoded_segments)]
        table.insert(decoded_output_digits, decoded_digit)
    end

    return decoded_output_digits
end


local function part_one(input)
    local decoded_digits = Utils.parse_input(input, decode)
    local count = 0
    local FILTER = Set.new({1, 4, 7, 8})

    for _, digits in ipairs(decoded_digits) do
        for _, digit in ipairs(digits) do
            if FILTER[digit] then
                count = count + 1
            end
        end
    end

    return count
end


local function part_two(input)
    local decoded_digits = Utils.parse_input(input, decode)

    local sum = 0
    for _, digits in ipairs(decoded_digits) do
        local number = 0
        for position, digit in ipairs(digits) do
            number = number + digit * 10 ^ (4 - position)
        end

        sum = sum + number
    end

    return math.floor(sum)
end


local PUZZLE = {
    year = 2021,
    day = 8
}

Utils.check(PUZZLE, part_one, 26, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 61229, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
