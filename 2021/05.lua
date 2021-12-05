local Utils = require("utils")


local Line = {}


Line.TYPE = {
    HORIZONTAL = 1,
    DIAGONAL = 2,
    VERTICAL = 3
}


function Line.parse(input)
    local x1, y1, x2, y2 = string.match(input, "(%d+),(%d+) %-> (%d+),(%d+)")
    local p1, p2 = { x = tonumber(x1) + 1, y = tonumber(y1) + 1 }, { x = tonumber(x2) + 1, y = tonumber(y2) + 1 }
    return (p1.x < p2.x or p1.y < p2.y) and { p1, p2 } or { p2, p1 }
end


function Line.get_type(line)
    if line[1].x == line[2].x then return Line.TYPE.HORIZONTAL end
    if line[1].y == line[2].y then return Line.TYPE.VERTICAL end
    return Line.TYPE.DIAGONAL
end


local Diagram = {}
Diagram._mt = { __index = Diagram }


function Diagram:mark_horizontal_line(line)
    assert(Line.get_type(line) == Line.TYPE.HORIZONTAL)
    local i = line[1].x
    for j = line[1].y, line[2].y do
        local cover = self.board[j][i] + 1
        self.board[j][i] = cover

        if cover == 2 then
            self.dangerous_amount = self.dangerous_amount + 1
        end
    end
end


function Diagram:mark_vertical_line(line)
    assert(Line.get_type(line) == Line.TYPE.VERTICAL)
    local j = line[1].y
    for i = line[1].x, line[2].x do
        local cover = self.board[j][i] + 1
        self.board[j][i] = cover

        if cover == 2 then
            self.dangerous_amount = self.dangerous_amount + 1
        end
    end
end


function Diagram:print()
    for j = 1, self.height do
        local row = ""
        for i = 1, self.width - 1 do
            row = row .. tostring(self.board[j][i]) .. " "
        end
        row = row .. tostring(self.board[j][self.width])

        print(row)
    end
end


function Diagram.new(width, height)
    local board = {}
    for _ = 1, height do
        local row = {}
        for _ = 1, width do
            table.insert(row, 0)
        end
        table.insert(board, row)
    end

    local self = {
        board = board,
        width = width,
        height = height,
        dangerous_amount = 0
    }

    return setmetatable(self, Diagram._mt)
end


local function parse_input(input)
    local width = 0
    local height = 0

    local lines = { {}, {}, {} }

    for _, line_input in ipairs(input) do
        local line = Line.parse(line_input)

        width = math.max(width, math.max(line[1].x, line[2].x))
        height = math.max(height, math.max(line[1].y, line[2].y))

        local type = Line.get_type(line)
        table.insert(lines[type], line)
    end

    return Diagram.new(width, height), lines
end


local function part_one(input)
    local diagram, lines = parse_input(input)

    for _, line in ipairs(lines[Line.TYPE.HORIZONTAL]) do
        diagram:mark_horizontal_line(line)
    end

    for _, line in ipairs(lines[Line.TYPE.VERTICAL]) do
        diagram:mark_vertical_line(line)
    end

    return diagram.dangerous_amount
end



local function part_two(input)
    return 0
end


local PUZZLE = {
    year = 2021,
    day = 5
}

Utils.check(PUZZLE, part_one, 5, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 0, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
