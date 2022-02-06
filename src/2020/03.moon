Utils = require("src.utils")
Utils.enable_string_indexing!


TREE = "#"
SLIDES = {
        { right: 1, down: 1 }
        { right: 3, down: 1 }
        { right: 5, down: 1 }
        { right: 7, down: 1 }
        { right: 1, down: 2 }
    }

count_trees = (rows, slide) ->
        trees_amount = 0
    
        { :down, :right } = slide
    
        assert(#rows >= 1)
        length = #(rows[1])
        
        position_x = 1
        for position_y = 1, #rows, down
            row = rows[position_y]
            char = row[position_x]
    
            trees_amount += 1 if char == TREE

            position_x = (position_x + right) % length
            position_x = length if position_x == 0
    
        trees_amount


parse_input = (input) -> input


part_one = (data) -> count_trees(data, SLIDES[2])


part_two = (data) ->
    results = [ count_trees(data, slide) for slide in *SLIDES ]

    output = 1
    for result in *results do
        output *= result

    output


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
        tests: 336
