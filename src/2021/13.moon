Utils = require("src.utils")


OTHER_AXIS = 
    x: "y"
    y: "x"

DOT_PATTERN = "(%d+),(%d+)"
FOLD_PATTERN = "fold along (%a)=(%d+)"


parse_input = (input) ->
    _, _, dots, folds = input\find("(.-)\n\n(.+)")

    dots = [ { x: tonumber(x), y: tonumber(y) } for x, y in dots\gmatch(DOT_PATTERN) ]
    folds = [ { :axis, line: tonumber(line) } for axis, line in folds\gmatch(FOLD_PATTERN) ]

    { :dots, :folds }


make_fold = (dots, fold) ->
    { :axis, :line } = fold

    unique = {}
    folded = {}
    
    mark = (value, other_value) ->
        set = unique[value] or {}
        return false if set[other_value]
        
        set[other_value] = true
        unique[value] = set
        
        true

    for dot in *dots
        value, other_value = dot[axis], dot[OTHER_AXIS[axis]]
        if value < line
            table.insert(folded, dot) if mark(value, other_value)
        elseif value > line
            value = 2 * line - value
            dot[axis] = value
            table.insert(folded, dot) if mark(value, other_value)
        else
            error("Dots should never appear exactly on a fold line")

    folded


part_one = (data) ->
    { :dots, :folds } = data
    assert(#folds >= 1)

    #(make_fold(dots, folds[1]))


part_two = (data) ->
    { :dots, :folds } = data
    for fold in *folds
        dots = make_fold(dots, fold)
    
    map = {}
    for dot in *dots
        set = map[dot.y] or {}
        set[dot.x] = true
        map[dot.y] = set

    local width, height
    for i = #folds, 1, -1
        fold = folds[i]
        switch fold.axis
            when 'x'
                continue if width
                width = fold.line
                break if height
            when 'y'
                continue if height
                height = fold.line
                break if width

    assert(width and height)

    rows = for j = 0, height - 1
        row = for i = 0, width - 1
            if map[j] and map[j][i] 
                '#'
            else
                '.'
        
        table.concat(row)
    
    table.concat(rows, '\n')


parts:
    [1]:
        read: Utils.read_raw
        parse: parse_input
        solution: part_one
        tests: 17
    [2]:
        read: Utils.read_raw
        parse: parse_input
        solution: part_two
        tests: '#####\n#...#\n#...#\n#...#\n#####\n.....\n.....'
