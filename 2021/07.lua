local Utils = require("utils")

local Swarm = {}
Swarm._mt = { __index = Swarm }


local function count_cost(swarm, target)
    local sum = 0
    for position, amount in pairs(swarm.positions) do
        local steps = math.abs(position - target)
        local cost = swarm.move_cost(steps) * amount
        sum = sum + cost
    end

    return sum
end


function Swarm:get_cost(position)
    local cost = self.costs[position]
    if not cost then
        cost = count_cost(self, position)
        self.costs[position] = cost
    end

    return cost
end


local function get_minimum(f, a, b)
    local k = (math.sqrt(5) - 1) / 2
    local function calc_xL(xA, xB) return math.floor(xB - k * (xB - xA)) end
    local function calc_xR(xA, xB) return math.ceil(xA + k * (xB - xA)) end

    local function get(xA, xB)
        if xB - xA == 2 then
            return math.min(f(xA), f(xA + 1), f(xB))
        end

        local xL, xR = calc_xL(xA, xB), calc_xR(xA, xB)
        -- print(xA, xL, xR, xB, f(xL), f(xR))
        return f(xL) < f(xR) and get(xA, xR) or get(xL, xB)
    end

    return get(a, b)
end


function Swarm:get_minimal_cost()
    return get_minimum(
        function(x)
            return self:get_cost(x)
        end,
        self.range.min,
        self.range.max
    )
end


function Swarm.new(params)
    local self = {
        positions = params.positions,
        range = params.range,
        costs = {},
        move_cost = params.move_cost
    }

    return setmetatable(self, Swarm._mt)
end


local function parse_input(raw_input)
    local positions = {}
    local min_position, max_position

    for position_input in string.gmatch(raw_input, "(%d+)") do
        local position = tonumber(position_input)
        min_position = not min_position and position or math.min(min_position, position)
        max_position = not max_position and position or math.max(max_position, position)

        local current = positions[position]
        positions[position] = not current and 1 or current + 1
    end

    return {
        positions = positions,
        range = { min = min_position, max = max_position }
    }
end


local function get_cost(input, move_cost)
    local params = parse_input(input)
    params.move_cost = move_cost

    local swarm = Swarm.new(params)
    return swarm:get_minimal_cost()
end


local function part_one(input)
    local function move_cost(steps)
        return steps
    end

    return get_cost(input, move_cost)
end


local function part_two(input)
    local function move_cost(steps)
        return ((steps + 1) * steps) // 2
    end

    return get_cost(input, move_cost)
end


local PUZZLE = {
    year = 2021,
    day = 7
}

Utils.check(PUZZLE, part_one, 37, Utils.read_raw)
Utils.run(PUZZLE, part_one, Utils.read_raw)

Utils.check(PUZZLE, part_two, 168, Utils.read_raw)
Utils.run(PUZZLE, part_two, Utils.read_raw)
