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
    return { p1, p2 }
end


function Line.get_type(line)
    if line[1].x == line[2].x then return Line.TYPE.HORIZONTAL end
    if line[1].y == line[2].y then return Line.TYPE.VERTICAL end
    return Line.TYPE.DIAGONAL
end


function Line.get_direction(line)
    local function d(axis)
        local result = line[2][axis] - line[1][axis]
        return result ~= 0 and result / math.abs(result) or 0
    end

    local dir = {}
    for _, axis in ipairs({ "x", "y" }) do
        dir[axis] = d(axis)
    end

    return dir
end


local Diagram = {}
Diagram._mt = { __index = Diagram }


function Diagram:mark_field(x, y)
    local cover = self.board[y][x] + 1
    self.board[y][x] = cover

    if cover == 2 then
        self.dangerous_amount = self.dangerous_amount + 1
    end
end


function Diagram:mark_line(line)
    if not self.accept_diagonal and Line.get_type(line) == Line.TYPE.DIAGONAL then
        return
    end

    local direction = Line.get_direction(line)

    local dx, dy = direction.x, direction.y
    local x, y = line[2].x, line[2].y

    local function mark_next(i, j)
        self:mark_field(i, j)
        if i == x and j == y then
            return
        end
        return mark_next(i + dx, j + dy)
    end

    return mark_next(line[1].x, line[1].y)
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


function Diagram.new(width, height, accept_diagonal)
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
        accept_diagonal = accept_diagonal,
        dangerous_amount = 0
    }

    return setmetatable(self, Diagram._mt)
end


local function parse_input(input, accept_diagonal)
    local width = 0
    local height = 0

    local lines = {}

    for _, line_input in ipairs(input) do
        local line = Line.parse(line_input)

        width = math.max(width, math.max(line[1].x, line[2].x))
        height = math.max(height, math.max(line[1].y, line[2].y))

        table.insert(lines, line)
    end

    return Diagram.new(width, height, accept_diagonal), lines
end


local function mark_lines(input, accept_diagonal)
    local diagram, lines = parse_input(input, accept_diagonal)

    for _, line in ipairs(lines) do
        diagram:mark_line(line)
    end

    return diagram.dangerous_amount
end


local function part_one(input)
    return mark_lines(input, false)
end


local function part_two(input)
    return mark_lines(input, true)
end


local PUZZLE = {
    year = 2021,
    day = 5
}

Utils.check(PUZZLE, part_one, 5, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 12, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
