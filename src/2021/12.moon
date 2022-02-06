Utils = require("src.utils")

START_CAVE = "start"
END_CAVE = "end"


parse_input = (input) ->
    SMALL_CAVE_PATTERN = "%l+"
    CONNECTION_PATTERN = "(%a+)-(%a+)"
    
    small_caves = {}
    neighbours = {}

    is_small_cave = (cave) -> cave\find(SMALL_CAVE_PATTERN)

    add_cave = (cave, neighbour) ->
        if is_small_cave(cave)
            small_caves[cave] = true
        else
            assert(is_small_cave(neighbour),
                "Graph contains two connected big caves - there is infinity number of paths")
        
        return if neighbour == START_CAVE

        cave_neighbours = neighbours[cave] or {}
        table.insert(cave_neighbours, neighbour)
        neighbours[cave] = cave_neighbours

    for connection in *input
        first_cave, second_cave = connection\match(CONNECTION_PATTERN)
        add_cave(first_cave, second_cave)
        add_cave(second_cave, first_cave)

    { :small_caves, :neighbours }


count_paths = (graph) -> 
    START_ID, END_ID = START_CAVE, END_CAVE
    
    visited_small_caves = {}

    dfs = (cave) ->
        return 1 if cave == END_ID
        return 0 if visited_small_caves[cave]

        visited_small_caves[cave] = true if graph.small_caves[cave]

        sum = 0
        for neighbour in *graph.neighbours[cave]
            sum += dfs(neighbour)

        visited_small_caves[cave] = nil

        sum

    dfs(START_ID)


count_extended_paths = (graph) ->
    
    dfs = (cave, special_cave, visited_small_caves) -> --, dump)
        -- dump = dump and (dump .. "," .. cave) or cave

        -- "someone" has set "start" to special cave, return
        return 0 if special_cave == START_CAVE 

        if cave == END_CAVE
            -- "someone" declared visit special cave and hasn't done it, return
            return 0 if special_cave and visited_small_caves[special_cave] and visited_small_caves[special_cave] ~= 2
            
            -- should be counted
            return 1

        visits = visited_small_caves[cave]
        if visits and visits > 0
            if cave == special_cave
                -- was in special cave second time, return
                return 0 if visits == 2 

            else
                -- was in normal small cave once
                return 0 if visits == 1

        sum = 0
        if not graph.small_caves[cave]
            -- multicave, visit it neighbours
            for neighbour in *graph.neighbours[cave]
                sum += dfs(neighbour, special_cave, visited_small_caves) -- , dump)

        else
            visited_small_caves[cave] = (visited_small_caves[cave] or 0) + 1

            for neighbour in *graph.neighbours[cave]
                if special_cave
                    -- special cave was already set, pass it further
                    sum += dfs(neighbour, special_cave, visited_small_caves) -- , dump)
                else
                    -- currrent cave will be special, test these paths
                    sum += dfs(neighbour, cave, visited_small_caves) -- , dump)
                    -- special cave will be choose later (or never)
                    sum += dfs(neighbour, nil, visited_small_caves) -- , dump)
            
            visited_small_caves[cave] = visited_small_caves[cave] - 1

        sum

    dfs(START_CAVE, nil, {}) --, nil)


part_one = (graph) -> count_paths(graph)


part_two = (graph) -> count_extended_paths(graph)


parts:
    [1]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_one
        tests:
            a: 10
            b: 19
            c: 226
    [2]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_two
        tests:
            a: 36
            b: 103
            c: 3509
