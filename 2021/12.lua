local Utils = require("utils")

local START_CAVE = "start"
local END_CAVE = "end"

local function parse_input(lines)
    local SMALL_CAVE_PATTERN = "%l+"

    local small_caves = {}
    local neighbours = {}

    local function is_small_cave(cave)
        return string.find(cave, SMALL_CAVE_PATTERN)
    end

    local function add_cave(cave, neighbour)
        if is_small_cave(cave) then
            small_caves[cave] = true
        else
            assert(is_small_cave(neighbour),
                "Graph contains two connected big caves - there is infinity number of paths")
        end

        if neighbour == START_CAVE then
            return
        end

        local cave_neighbours = neighbours[cave] or {}
        table.insert(cave_neighbours, neighbour)
        neighbours[cave] = cave_neighbours
    end

    for _, connection in ipairs(lines) do
        local first_cave, second_cave = string.match(connection, "(%a+)-(%a+)")

        add_cave(first_cave, second_cave)
        add_cave(second_cave, first_cave)
    end

    return {
        small_caves = small_caves,
        neighbours = neighbours
    }
end


local function count_paths(graph)
    local START_ID = "start"
    local END_ID = "end"

    local visited_small_caves = {}

    local function dfs(cave)
        if cave == END_ID then return 1 end
        if visited_small_caves[cave] then return 0 end

        if graph.small_caves[cave] then
            visited_small_caves[cave] = true
        end

        local sum = 0
        for _, neighbour in ipairs(graph.neighbours[cave]) do
            local count = dfs(neighbour)
            sum = sum + count
        end

        visited_small_caves[cave] = nil

        return sum
    end

    return dfs(START_ID)
end


local function count_extended_paths(graph)
    

    local function dfs(cave, special_cave, visited_small_caves) -- , dump)
        -- dump = dump and (dump .. "," .. cave) or cave

        if special_cave == START_CAVE then
            -- "someone" has set "start" to special cave, return
            return 0
        end

        if cave == END_CAVE then
            if special_cave and visited_small_caves[special_cave] and visited_small_caves[special_cave] ~= 2 then
                -- "someone" declared visit special cave and hasn't done it, return
                return 0
            end
            -- should be counted
            return 1
         end

        local visits = visited_small_caves[cave]
        if visits and visits > 0 then
            if cave == special_cave then
                if visits == 2 then 
                    -- was in special cave second time, return
                    return 0
                end
            else
                if visits == 1 then
                    -- was in normal small cave once
                    return 0
                end
            end
        end

        local sum = 0
        if not graph.small_caves[cave] then
            -- multicave, visit it neighbours
            for _, neighbour in ipairs(graph.neighbours[cave]) do
                local count = dfs(neighbour, special_cave, visited_small_caves) -- , dump)
                sum = sum + count
            end
        else
            visited_small_caves[cave] = (visited_small_caves[cave] or 0) + 1

            for _, neighbour in ipairs(graph.neighbours[cave]) do
                if special_cave then
                    -- special cave was already set, pass it further
                    sum = sum + dfs(neighbour, special_cave, visited_small_caves) -- , dump)
                else
                    -- currrent cave will be special, test these paths
                    sum = sum + dfs(neighbour, cave, visited_small_caves) -- , dump)
                    -- special cave will be choose later (or never)
                    sum = sum + dfs(neighbour, nil, visited_small_caves) -- , dump)
                end
            end

            visited_small_caves[cave] = visited_small_caves[cave] - 1
        end

        return sum
    end

    return dfs(START_CAVE, nil, {}) --, nil)
end

local function part_one(input)
    local graph = parse_input(input)
    return count_paths(graph)
end


local function part_two(input)
    local graph = parse_input(input)
    return count_extended_paths(graph)
end

local PUZZLE = {
    year = 2021,
    day = 12
}

local part_one_tests = {
    a = 10,
    b = 19,
    c = 226
}
Utils.multicheck(PUZZLE, part_one, part_one_tests, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

local second_part_tests = {
    a = 36,
    b = 103,
    c = 3509,
}
Utils.multicheck(PUZZLE, part_two, second_part_tests, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
