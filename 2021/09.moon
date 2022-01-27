Utils = require("utils")
Utils.enable_string_indexing!


-- parse_input = (input) -> [ [ tonumber(depth) for depth in line\gmatch("%d") ] for line in *input ]
        
-- part_one = (area) ->
--     get = (x, y) -> area[y][x]
    
--     height = #area
--     assert(height > 0)

--     width = #(area[1])
--     assert(width > 0)

--     offsets = {
--         { x: -1, y:  0 },
--         { x:  1, y:  0 },
--         { x:  0, y:  1 },
--         { x:  0, y: -1 }
--     }

--     get_neighbours = (x, y) ->
--         ox, oy = x, y

--         return for offset in *offsets
--             x = ox + offset.x
--             y = oy + offset.y

--             continue unless (1 <= x and x <= width) and (1 <= y and y <= height)
            
--             get(x, y)

--     is_low = (x, y) ->
--         value = get(x, y)
--         for neighbour in *get_neighbours(x, y)
--             if value >= neighbour then
--                 return false

--         true

--     sum = 0
--     for j, row in ipairs(area) do
--         for i, _ in ipairs(row) do
--             sum += get(i, j) + 1 if is_low(i, j)
    
--     sum


parse_input = (input) ->
    list, map = {}, {}
    
    height = #input
    assert(height > 0)
    width = #(input[1])
    assert(width > 0)

    get_node = (id, depth) ->
        return nil if depth == 9
                
        node = map[id]
        unless node
            node = { :id, :depth, neighbours: {} }
            map[id] = node
            table.insert(list, node)

        node

    link = (node, neighbour) ->
        return unless neighbour
        
        table.insert(node.neighbours, neighbour)
        table.insert(neighbour.neighbours, node)

    id = 0
    for j = 1, height
        line = input[j]

        for i = 1, width
            id += 1

            if node = get_node(id, tonumber(line[i]))
                unless j == height
                    link(node, get_node(id + width, tonumber(input[j + 1][i])))
                unless i == width
                    link(node, get_node(id + 1, tonumber(line[i + 1])))
    
    { :list, :map }


part_one = (data) ->
    get_lowest = (node) ->
        node.visited = true

        low_point = node.depth
        for neighbour in *node.neighbours
            unless neighbour.visited
                low_point = math.min(low_point, get_lowest(neighbour))
        
        low_point
    
    sum = 0
    for node in *data.list
        unless node.visited
            sum += (get_lowest(node) + 1)

    sum


part_two = (data) ->
    count_size = (node) ->
        node.visited = true

        count = 0
        for neighbour in *node.neighbours
            unless neighbour.visited
                count += count_size(neighbour)
        
        count + 1
    
    sizes = [ count_size(node) for node in *data.list when not node.visited ]
    
    n = #sizes
    assert(n >= 3)
    table.sort(sizes)

    sizes[n] * sizes[n - 1] * sizes[n - 2]


Utils.run
    number:
        year: 2021, 
        day: 9
    parts:
        [1]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_one
            tests: 15
        [2]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_two
            tests: 1134
