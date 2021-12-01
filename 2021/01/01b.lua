local filename = arg[1]
assert(filename)

local WINDOW_SIZE = 3
local window = {}

local increase_count = 0
local previous_sum = 0

for line in io.lines(filename) do
    local depth = tonumber(line)
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

print(increase_count)
