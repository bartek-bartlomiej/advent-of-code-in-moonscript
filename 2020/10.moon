Utils = require("utils")

MAX_DIFF = 3

parse_input = (input) -> 
    with data = [ tonumber(x) for x in *input ]
        table.insert(data, 0)
        table.sort(data)
        table.insert(data, data[#data] + MAX_DIFF)


part_one = (data) ->
    differences = { 0, 0, 0 }
    for i = 2, #data
        difference = data[i] - data[i - 1]
        assert(1 <= difference and difference <= MAX_DIFF)
        differences[difference] += 1
    
    differences[1] * differences[MAX_DIFF]
    

part_two = (data) ->
    cache = {}

    is_last = (i) ->
        i + 1 <= #data and data[i + 1] - data[i] >= MAX_DIFF

    can_step = (i, step) ->
        i + step <= #data and data[i + step] - data[i] <= MAX_DIFF

    step = (i) ->
        return cache[i] if cache[i]
        
        if is_last(i)
            cache[i] = 1
            return 1, i + 1

        -- j = 1
        count, next = step(i + 1)
        -- j = 2, 3
        for j = 2, MAX_DIFF
            break if not can_step(i, j)
            sub_count = step(i + j)
            count += sub_count

        cache[i] = count
        
        count, next

    arrangements = 1
    i = 1
    while i < #data
        count, i = step(i)
        arrangements *= count       
    
    arrangements


Utils.run
    number:
        year: 2020, 
        day: 10
    parts:
        [1]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_one
            tests:
                a: 35
                b: 220
        [2]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_two
            tests:
                a: 8
                b: 19208
