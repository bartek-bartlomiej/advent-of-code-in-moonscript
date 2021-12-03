local Utils = require("utils")


local function part_one(input)
    local numbers = Utils.parse_input(input, tonumber)

    table.insert(numbers, 0)
    table.sort(numbers)
    table.insert(numbers, numbers[#numbers] + 3)

    local differences = {0, 0, 0}
    for i = 2, #numbers do
        local difference = numbers[i] - numbers[i - 1]
        assert(1 <= difference and difference <= 3)

        differences[difference] = differences[difference] + 1
    end

    print(differences[1], differences[3])
    return differences[1] * differences[3]
end


local function part_two(input)
    return 8
end


local PUZZLE = {
    year = 2020,
    day = 10
}

Utils.check(PUZZLE, part_one, 220, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 8, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
