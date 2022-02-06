Utils = require("src.utils")
{ :floor, :ceil, :min, :max, :sqrt, :abs } = math


class Swarm
    new: (positions, range, move_cost) =>
        @positions = positions
        @range = range
        @costs = {}
        @move_cost = move_cost

    
    count_cost = (@, target) ->
        sum = 0
        for position, amount in pairs(@positions)
            steps = abs(position - target)
            sum += @.move_cost(steps) * amount
        
        sum

    get_cost: (position) =>
        cost = @costs[position]
        if not cost
            cost = count_cost(@, position)
            @costs[position] = cost

        cost

    get_minimum = (f, a, b) ->
        k = (sqrt(5) - 1) / 2
        calc_xL = (xA, xB) -> floor(xB - k * (xB - xA))
        calc_xR = (xA, xB) -> ceil(xA + k * (xB - xA))
    
        get = (xA, xB) ->
            if xB - xA == 2
                return min(f(xA), f(xA + 1), f(xB))
    
            xL, xR = calc_xL(xA, xB), calc_xR(xA, xB)
                        
            if f(xL) < f(xR) then get(xA, xR) else get(xL, xB)
    
        get(a, b)

    get_minimal_cost: () =>
        get_minimum(
            (x) -> @get_cost(x),
            @range.min,
            @range.max)


parse_input = (input) ->
    local min_position, max_position
    positions = {}

    for position in input\gmatch("(%d+)")
        position = tonumber(position)
        min_position = min_position and min(min_position, position) or position
        max_position = max_position and max(max_position, position) or position
        
        current = positions[position]
        positions[position] = current and (current + 1) or 1

    { :positions, range: { min: min_position, max: max_position } }


get_cost = (data, move_cost) ->
    Swarm(data.positions, data.range, move_cost)\get_minimal_cost!


part_one = (data) ->
    get_cost(data, (steps) -> steps)


part_two = (data) ->
    get_cost(data, (steps) -> ((steps + 1) * steps) // 2)


parts:
    [1]:
        read: Utils.read_raw
        parse: parse_input
        solution: part_one
        tests: 37
    [2]:
        read: Utils.read_raw
        parse: parse_input
        solution: part_two
        tests: 168
