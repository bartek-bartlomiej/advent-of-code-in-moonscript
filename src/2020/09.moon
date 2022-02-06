Utils = require("src.utils")


class Window
    new: (numbers, size) =>
        for i = 1, size do table.insert(@, numbers[i])
        table.sort(@)
    

    get_rounded_half = (x, y) -> (x + y) // 2 + (x + y) % 2


    binary_search = (t, x, cb) ->
        local find = (i, j) ->
            return cb(i, false) if j < i
            
            mid = get_rounded_half(i, j)
            test = t[mid]
            
            if test > x
                find(i, mid - 1)
            elseif test < x
                find(mid + 1, j)
            else
                cb(mid, true)

        find(1, #t)


    find = (number) =>
        callback = (i, found) -> i if found
        
        binary_search(@, number, callback)
    

    remove = (number) => 
        callback = (i, found) -> 
            assert(found)
            table.remove(@, i)

        binary_search(@, number, callback)

    
    insert = (number) =>
        callback = (i) -> 
            table.insert(@, i, number)
        
        binary_search(@, number, callback)


    has_pair: (sum) =>
        for i = 1, #@ do
            first = @[i]
            second = sum - first

            return true if first ~= second and find(@, second)
                
        false


    shift: (prev_number, next_number) =>
        remove(@, prev_number)
        insert(@, next_number)


find_invalid_number = (numbers, window_size) ->
    window = Window(numbers, window_size)

    for i = window_size + 1, #numbers
        current_number = numbers[i]
        return current_number if not window\has_pair(current_number)
        
        window\shift(numbers[i - window_size], current_number)

    error("Invalid number not found")


find_contiguous_set = (numbers, sum) -> 
    size = #numbers
    assert(size >= 2)

    local calc

    add = (i, j, acc) ->
        error("Set not found") if j == size
        
        calc(i, j + 1, acc + numbers[j + 1])

    substract = (i, j, acc) -> 
        calc(i + 1, j, acc - numbers[i])


    calc = (i, j, acc) ->
        return add(i, j, acc) if i == j

        if acc < sum
            add(i, j, acc)
        elseif acc > sum then
            substract(i, j, acc)
        else
            i, j

    calc(1, 2, numbers[1] + numbers[2])


find_min_max = (numbers, first, last) ->
    min, max = numbers[first], numbers[last]
    min, max = max, min if min > max
        
    for i = first + 1, last
        number = numbers[i]
        if number < min
            min = number
        elseif number > max
            max = number

    min, max


TEST_WINDOW_SIZE = 5
WINDOW_SIZE = 25


parse_input = (input) -> [ tonumber(x) for x in *input ]


part_one = (data, size) ->
    find_invalid_number(data, size)


part_two = (data, size) ->
    invalid_number = find_invalid_number(data, size)

    first_element, last_element = find_contiguous_set(data, invalid_number)
    min, max = find_min_max(data, first_element, last_element)
    
    min + max


parts:
    [1]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_one
        tests: 127
        arguments:
            solution: WINDOW_SIZE
            tests: TEST_WINDOW_SIZE
    [2]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_two
        tests: 62
        arguments:
            solution: WINDOW_SIZE
            tests: TEST_WINDOW_SIZE
