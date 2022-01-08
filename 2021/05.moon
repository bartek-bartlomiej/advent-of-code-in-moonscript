Utils = require("utils")

class Line
    @TYPE:
        HORIZONTAL: 1
        DIAGONAL: 2
        VERTICAL: 3

    
    new: (a, b) =>
        @points = { a, b }

    
    get_type: () =>
        return Line.TYPE.HORIZONTAL if @points[1].x == @points[2].x
        return Line.TYPE.VERTICAL if @points[1].y == @points[2].y
        Line.TYPE.DIAGONAL

    
    get_direction: () =>
        d = (axis) ->
            result = @points[2][axis] - @points[1][axis]
            if result ~= 0
                result / math.abs(result)
            else
                0

        { axis, d(axis) for axis in *{"x", "y"} }


class Diagram
    new: (width, height) =>
        @board = [ [ 0 for _ = 1, width ] for _ = 1, height ]
        @size = { :width, :height }
        @accept_diagonal = false
        @dangerous_amount = 0

    
    print: () =>
        { :width, :height } = @size
        for j = 1, height
            for i = 1, width
                io.write("#{@board[j][i]}", if i < width then " " else "\n")
    
    
    mark_field = (@, x, y) ->
        cover = @board[y][x] + 1
        @board[y][x] = cover
        @dangerous_amount += 1 if cover == 2

    
    mark_line: (line) =>
        return if not @accept_diagonal and line\get_type! == Line.TYPE.DIAGONAL
        { x: dx, y: dy } = line\get_direction!
        { { x: ax, y: ay }, { x: bx, y: by } } = line.points

        mark_next = (i, j) ->
            mark_field(@, i, j)
            return if i == bx and j == by
            mark_next(i + dx, j + dy)
        
        mark_next(ax, ay)


parse_point = (x, y) -> { x: tonumber(x) + 1, y: tonumber(y) + 1}


parse_line = (line) ->
    ax, ay, bx, by = string.match(line, "(%d+),(%d+) %-> (%d+),(%d+)")
    parse_point(ax, ay), parse_point(bx, by)
    

parse_input = (input) -> 
    width = 0
    height = 0

    lines = for line in *input
        a, b = parse_line(line) 
        width = math.max(width, math.max(a.x, b.x))
        height = math.max(height, math.max(a.y, b.y))
        Line(a, b)

    { diagram: Diagram(width, height), :lines }


mark_lines = (data, accept_diagonal) ->
    { :diagram, :lines } = data
    diagram.accept_diagonal = accept_diagonal
    for line in *lines do diagram\mark_line(line)

    diagram.dangerous_amount


part_one = (data) ->
    mark_lines(data, false)


part_two = (data) ->
    mark_lines(data, true)


Utils.run
    number:
        year: 2021, 
        day: 5
    parts:
        [1]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_one
            tests: 5
        [2]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_two
            tests: 12