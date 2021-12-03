local Utils = require("utils")

local SHINY_GOLD = "shiny gold"


local function parse_line(line)
    local _, _, color, neighbours_list = string.find(line, "(.+) bags contain (.+)")

    local neighbours = {}
    for neighbour_amount, neighbour_color in string.gmatch(neighbours_list, "(%d+) (.-) bags?") do
        local neighbour = { color = neighbour_color, amount = neighbour_amount }
        table.insert(neighbours, neighbour)
    end

    return {
        color = color,
        inside = {},
        contains = neighbours
    }
end


local function parse_input(input)
    local bags = {}

    for _, line in ipairs(input) do
        local bag = parse_line(line)

        table.insert(bags, bag)
        bags[bag.color] = bag
    end

    for _, bag in ipairs(bags) do
        for _, neighbour in ipairs(bag.contains) do
            table.insert(bags[neighbour.color].inside, bag.color)
        end
    end

    return bags
end

local function part_one(input)
    local bags = parse_input(input)

    local visited = {}
    local to_visit = {}
    for _, parent_color in ipairs(bags[SHINY_GOLD].inside) do
        table.insert(to_visit, parent_color)
    end

    while #to_visit > 0 do
        local color = table.remove(to_visit)

        if not visited[color] then
            visited[color] = true
            table.insert(visited, color)

            for _, parent_color in ipairs(bags[color].inside) do
                table.insert(to_visit, parent_color)
            end
        end
    end

    return #visited
end


local function part_two(input)
    local bags = parse_input(input)

    local total_amount = 0
    local to_visit = { { color = SHINY_GOLD, amount = 1 } }

    while #to_visit > 0 do
        local bag = table.remove(to_visit)

        for _, neighbour in ipairs(bags[bag.color].contains) do
            local amount = bag.amount * neighbour.amount
            total_amount = total_amount + amount

            table.insert(to_visit, { color = neighbour.color, amount = amount })
        end
    end

    return math.floor(total_amount)
end


local PUZZLE = {
    year = 2020,
    day = 7
}

Utils.check(PUZZLE, part_one, 4, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 32, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
