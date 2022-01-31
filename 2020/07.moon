Utils = require("utils")


LINE_PATTERN = "(.+) bags contain (.+)"
NEIGHBOURS_PATTERN = "(%d+) (.-) bags?"

SHINY_GOLD = "shiny gold"

parse_line = (line) ->
    _, _, color, neighbours_list = line\find(LINE_PATTERN)
    neighbours = for neighbour_amount, neighbour_color in neighbours_list\gmatch(NEIGHBOURS_PATTERN)
        { color: neighbour_color, amount: neighbour_amount }

    { :color, inside: {}, contains: neighbours }


parse_input = (input) ->
    bags = {}

    for line in *input
        with bag = parse_line(line)
            table.insert(bags, bag)
            bags[bag.color] = bag
    
    for bag in *bags do
        for neighbour in *bag.contains do
            table.insert(bags[neighbour.color].inside, bag.color)

    bags


part_one = (bags) ->
    visited = {}
    to_visit = [ parent_color for parent_color in *bags[SHINY_GOLD].inside ]   

    while #to_visit > 0 do
        color = table.remove(to_visit)

        continue if visited[color]

        visited[color] = true
        table.insert(visited, color)

        for parent_color in *bags[color].inside
            table.insert(to_visit, parent_color)

    #visited


part_two = (bags) ->
    total_amount = 0
    to_visit = { { color: SHINY_GOLD, amount: 1 } }

    while #to_visit > 0 do
        bag = table.remove(to_visit)

        for neighbour in *bags[bag.color].contains
            amount = bag.amount * neighbour.amount
            total_amount += amount

            table.insert(to_visit, { color: neighbour.color, amount: amount })

    math.floor(total_amount)


Utils.run
    number:
        year: 2020, 
        day: 7
    parts:
        [1]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_one
            tests: 4
        [2]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_two
            tests: 32
