local Utils = require("utils")


function part_one(input)
    return 0
end


function part_two(input)
    return 0
end


local PUZZLE = {
    year = nil,
    day = nil
}

Utils.check(PUZZLE, part_one, 0, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 0, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
