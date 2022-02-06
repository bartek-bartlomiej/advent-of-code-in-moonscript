number = assert(arg[1], "Puzzle number is missing")
year, day = string.match(number, "(%d%d%d%d)/(%d%d)")
assert(year, "Wrong puzzle number format, required YYYY/DD, get #{number}")

puzzle = require("src.#{year}.#{day}")
puzzle.number =
    year: tonumber(year)
    day: tonumber(day)

Utils = require("src.utils")
Utils.run(puzzle)
