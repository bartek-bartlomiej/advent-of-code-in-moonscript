local Utils = require("utils")


local Window = {}

Window.SIZE = 25


local function calc_rounded_half(number, y)
    local sum = number + y
    return sum // 2 + sum % 2
end


local function binary_search(t, x, callback)
    function find(i, j)
        if j < i then 
            return callback(i, false)
        end

        local mid = calc_rounded_half(i, j)
        local test = t[mid]

        if test > x then
            return find(i, mid - 1)
        elseif test < x then
            return find(mid + 1, j)
        else
            return callback(mid, true)
        end
    end

    return find(1, #t)
end


function Window:find(number)
    return binary_search(self, number, function(i, found) 
        if found then return i else return nil end 
    end)
end


function Window:remove(number)
    return binary_search(self, number, function(i, found) 
        assert(found)
        table.remove(self, i)
    end)
end


function Window:insert(number)
    return binary_search(self, number, function(i) 
        table.insert(self, i, number)
        return i
    end)
end


function Window:has_pair(sum)
    for i = 1, #self do
        local first = self[i]
        local second = sum - first

        if first ~= second and self:find(second) then
            return true
        end
    end

    return false
end


function Window:shift(prev_number, next_number)
    self:remove(prev_number)
    self:insert(next_number)
end


function Window.new(numbers)
    local window = {}
    for i = 1, Window.SIZE do
        table.insert(window, numbers[i])
    end
    table.sort(window)

    return setmetatable(window, { __index = Window })
end


function find_invalid_number(numbers)
    local window = Window.new(numbers)

    for i = Window.SIZE + 1, #numbers do
        local current_number = numbers[i]
        
        if not window:has_pair(current_number) then
            return current_number
        end

        window:shift(numbers[i - Window.SIZE], current_number)
    end

    error("Invalid number not found")
end



function find_contiguous_set(sum, numbers)
    assert(#numbers >= 2)
    local current_sum = numbers[1] + numbers[2]
    local i, j = 1, 2
    local size = #numbers

    function add()
        if j + 1 > size then 
            return false
        end
        j = j + 1
        current_sum = current_sum + numbers[j]
        return true
    end

    function substract()
        current_sum = current_sum - numbers[i]
        i = i + 1
    end

    while true do
        if current_sum < sum then
            if not add() then 
                break 
            end
        elseif current_sum > sum then
            if i == j and not add() then
                break
            end
            substract()
        else
            if i == j and not add() then
                break
            end
            
            return i, j
        end
    end

    error("Set not found")
end


function find_min_max(numbers, first, last)
    local min, max = numbers[first], numbers[last]
    if min > max then
        min, max = max, min
    end

    for i = first + 1, last do
        local number = numbers[i]
        if number < min then
            min = number
        elseif number > max then
            max = number
        end
    end

    return min, max
end

function part_one(input)
    local numbers = Utils.parse_input(input, tonumber)
    return find_invalid_number(numbers)
end


function part_two(input)
    local numbers = Utils.parse_input(input, tonumber)
    local invalid_number = find_invalid_number(numbers)
    
    local first_element, last_element = find_contiguous_set(invalid_number, numbers)
    local min, max = find_min_max(numbers, first_element, last_element)
    return min + max
end


function test_part_one(input)
    local default_size = Window.SIZE
    Window.SIZE = 5
    local result = part_one(input)
    Window.SIZE = default_size

    return result
end


function test_part_two(input)
    local default_size = Window.SIZE
    Window.SIZE = 5
    local result = part_two(input)
    Window.SIZE = default_size

    return result
end


local PUZZLE = {
    year = 2020,
    day = 9
}


Utils.check(PUZZLE, test_part_one, 127, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, test_part_two, 62, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
