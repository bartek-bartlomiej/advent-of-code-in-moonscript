local filename = arg[1]
assert(filename)

local increase_count = 0
local previous_depth

for line in io.lines(filename) do
    local depth = tonumber(line)
    assert(depth)

    if previous_depth and previous_depth < depth then
        increase_count = increase_count + 1
    end
    previous_depth = depth
end

print(increase_count)
