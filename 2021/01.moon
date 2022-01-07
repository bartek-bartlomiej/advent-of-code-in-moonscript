Utils = require("utils")


parse_input = (input) -> [ tonumber(line) for line in *input ]


part_one = (depths) ->
    count = 0    
    previous_depth = depths[1]
    
    for depth in *depths[2, #depths]
        count += 1 if previous_depth < depth
        previous_depth = depth

    count


part_two = (depths) ->
    WINDOW_SIZE = 3
    window = {}

    count = 0
    previous_sum = 0

    for depth in *depths[1, WINDOW_SIZE]
        table.insert(window, depth)
        previous_sum += depth

    for depth in *depths[WINDOW_SIZE + 1, #depths]
        previous_depth = table.remove(window, 1)
        table.insert(window, depth)

        sum = previous_sum - previous_depth + depth
        count += 1 if previous_sum < sum
        previous_sum = sum
    
    count


Utils.run
    number:
        year: 2021, 
        day: 1
    parts:
        [1]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_one
            tests: 7
        [2]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_two
            tests: 5
