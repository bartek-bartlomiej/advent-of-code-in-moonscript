local Utils = require("utils")


local parse_line = tonumber


function parse_input(input)
    local list = {}
    
    for _, line in ipairs(input) do
        local number = parse_line(line)
        assert(number)

        table.insert(list, number)
    end

    return list
end


function part_one(input)

    function find_numbers(list)
        for i = 1, #list do
            for j = i + 1, #list do
                local n1 = list[i]
                local n2 = list[j]
        
                if n1 + n2 == 2020 then
                    return n1, n2
                end
            end
        end
    
        return nil
    end

    local list = parse_input(input)
    local n1, n2 = find_numbers(list)

    return n1 * n2
end


function part_two(input)

    function find_numbers(list)
        for i = 1, #list do
            for j = i + 1, #list do
                for k = j + 1, #list do
                    local n1 = list[i]
                    local n2 = list[j]
                    local n3 = list[k]
            
                    if n1 + n2 + n3 == 2020 then
                        return n1, n2, n3
                    end
                end
            end
        end
    
        return nil
    end
    
    local list = parse_input(input)
    local n1, n2, n3 = find_numbers(list)
    
    assert(n1, "Numbers not found")
    -- print(n1 .. " & " .. n2 .. " & " .. n3)
    
    return n1 * n2 * n3
end


local PUZZLE = {
    year = 2020,
    day = 1
}

Utils.check(PUZZLE, part_one, 514579, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 241861950, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
