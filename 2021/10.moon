Utils = require("utils")

MATCH = do
    BRACKETS = { "()", "[]", "{}", "<>" }

    dict =
        LEFT: {}
        RIGHT: {}

    for pair in *BRACKETS
        left, right = pair\match("(.)(.)")
        dict.LEFT[left] = right
        dict.RIGHT[right] = left

    dict


CHECK_RESULT =
    OK: 0
    INCOMPLETE: 1
    CORRUPTED: 2


check_line = (line) ->
    open_chunks = {}
    
    for character in line\gmatch(".")
        if MATCH.LEFT[character]
            table.insert(open_chunks, character)
        elseif MATCH.RIGHT[character]
            top = table.remove(open_chunks)
            if MATCH.RIGHT[character] ~= top
                return CHECK_RESULT.CORRUPTED, character
        else
            error("Unexpected symbol: " .. character)

    if #open_chunks > 0
        return CHECK_RESULT.INCOMPLETE, open_chunks
    
    CHECK_RESULT.OK


parse_input = (input) -> input


part_one = (data) ->
    scores =
        [")"]: 3
        ["]"]: 57
        ["}"]: 1197
        [">"]: 25137

    counts = with {}
        for right, _ in pairs(MATCH.RIGHT)
            [right] = 0

    for line in *data
        result, character = check_line(line)
        if result == CHECK_RESULT.CORRUPTED
            counts[character] += 1

    sum = 0
    for character, value in pairs(counts) do
        sum += scores[character] * value
    
    sum


part_two = (data) ->
    scores =
        [")"]: 1
        ["]"]: 2
        ["}"]: 3
        [">"]: 4

    count_score = (open_chunks) ->
        score = 0
        for i = #open_chunks, 1, -1
            character = open_chunks[i]
            score = 5 * score + scores[MATCH.LEFT[character]]
        
        score

    points = for line in *data
        result, open_chunks = check_line(line)
        continue unless result == CHECK_RESULT.INCOMPLETE
        
        count_score(open_chunks)
        
    table.sort(points)
    
    points[#points // 2 + 1]


Utils.run
    number:
        year: 2021, 
        day: 10
    parts:
        [1]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_one
            tests: 26397
        [2]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_two
            tests: 288957
