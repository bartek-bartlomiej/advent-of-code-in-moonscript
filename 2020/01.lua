local Utils = require("utils")


local function part_one(input)

    local function find_numbers(list)
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

    local list = Utils.parse_input(input, tonumber)
    local n1, n2 = find_numbers(list)

    return n1 * n2
end


local function part_two(input)

    local function find_numbers(list)
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

    local list = Utils.parse_input(input, tonumber)
    local n1, n2, n3 = find_numbers(list)

    assert(n1, "Numbers not found")

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
