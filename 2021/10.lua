local Utils = require("utils")


local function generate_matching_dict()
    local brackets = { "()", "[]", "{}", "<>" }
    local dict = {
        LEFT = {},
        RIGHT = {}
    }

    for _, pair in ipairs(brackets) do
        local left, right = string.match(pair, "(.)(.)")
        dict.LEFT[left] = right
        dict.RIGHT[right] = left
    end

    return dict
end

local MATCH = generate_matching_dict()


local CHECK_RESULT = {
    OK = 0,
    INCOMPLETE = 1,
    CORRUPTED = 2
}

local function check_line(line)
    local open_chunks = {}
    for character in string.gmatch(line, ".") do
        if MATCH.LEFT[character] then
            table.insert(open_chunks, character)
        elseif MATCH.RIGHT[character] then
            local top = table.remove(open_chunks)
            if MATCH.RIGHT[character] ~= top then
                return CHECK_RESULT.CORRUPTED, character
            end
        else
            error("Unexpected symbol: " .. character)
        end
    end

    if #open_chunks > 0 then
        return CHECK_RESULT.INCOMPLETE, open_chunks
    else
        return CHECK_RESULT.OK
    end
end


local function part_one(input)
    local scores = {
        [")"] = 3,
        ["]"] = 57,
        ["}"] = 1197,
        [">"] = 25137
    }

    local counts = {}
    for right, _ in pairs(MATCH.RIGHT) do
        counts[right] = 0
    end

    for _, line in ipairs(input) do
        local result, right = check_line(line)
        if result == CHECK_RESULT.CORRUPTED then
            counts[right] = counts[right] + 1
        end
    end

    local sum = 0
    for right, value in pairs(counts) do
        sum = sum + scores[right] * value
    end

    return sum
end


local function part_two(input)
    local scores = {
        [")"] = 1,
        ["]"] = 2,
        ["}"] = 3,
        [">"] = 4
    }

    local count_score = function(open_chunks)
        local score = 0
        for i = #open_chunks, 1, -1 do
            local left = open_chunks[i]
            score = 5 * score + scores[MATCH.LEFT[left]]
        end
        return score
    end

    local points = {}

    for _, line in ipairs(input) do
        local result, open_chunks = check_line(line)
        if result == CHECK_RESULT.INCOMPLETE then
            table.insert(points, count_score(open_chunks))
        end
    end

    table.sort(points)
    return points[#points // 2 + 1]
end


local PUZZLE = {
    year = 2021,
    day = 10
}

Utils.check(PUZZLE, part_one, 26397, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 288957, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
