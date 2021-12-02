local utils = require('utils')


local parse_line = tonumber


function part_one(input)
    local increase_count = 0
    local previous_depth

    for _, line in ipairs(input) do
        local depth = parse_line(line)
        assert(depth)

        if previous_depth and previous_depth < depth then
            increase_count = increase_count + 1
        end
        previous_depth = depth
    end

    return increase_count
end


function part_two(input)
    local WINDOW_SIZE = 3
    local window = {}

    local increase_count = 0
    local previous_sum = 0

    for _, line in ipairs(input) do
        local depth = parse_line(line)
        assert(depth)

        if #window ~= WINDOW_SIZE then
            table.insert(window, depth)
            previous_sum = previous_sum + depth    
        else
            local current_sum = previous_sum - window[1] + depth
            table.remove(window, 1)
            table.insert(window, depth)

            if previous_sum < current_sum then
                increase_count = increase_count + 1
            end

            previous_sum = current_sum
        end
    end

    return increase_count
end


local PUZZLE = {
    year = 2021,
    day = 1
}

utils.check(PUZZLE, part_one, 7, utils.read_lines)
utils.run(PUZZLE, part_one, utils.read_lines)

utils.check(PUZZLE, part_two, 5, utils.read_lines)
utils.run(PUZZLE, part_two, utils.read_lines)
