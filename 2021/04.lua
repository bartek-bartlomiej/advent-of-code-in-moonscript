local Utils = require("utils")


local BingoBoard = {}
BingoBoard._mt = { __index = BingoBoard }


function BingoBoard:mark(number)
    local data = self.numbers_data[number]

    if not data then
        return
    end

    assert(not data.marked)
    data.marked = true

    local row, col = data.position.x, data.position.y

    self.marked_in_rows[row] = self.marked_in_rows[row] + 1
    self.marked_in_columns[col] = self.marked_in_columns[col] + 1
    self.marked_sum = self.marked_sum + number

    if self.marked_in_rows[row] == self.size.width then
        self.winning = true
        return true
    end

    if self.marked_in_columns[col] == self.size.height then
        self.winning = true
        return true
    end

    return false
end


function BingoBoard:sum_row(index)
    local width = self.size.width
    assert(1 <= index and index <= width)

    local sum = 0
    for _, number in ipairs(self.board[index]) do
        sum = sum + number
    end

    return sum
end


function BingoBoard:sum_column(index)
    local height = self.size.height
    assert(1 <= index and index <= height)

    local sum = 0
    for _, row in ipairs(self.board) do
        sum = sum + row[index]
    end

    return sum
end


function BingoBoard.new(board)
    local numbers_data = {}
    local marked_in_rows = {}
    local marked_in_columns = {}
    local numbers_sum = 0

    local height = #board
    assert(height > 0)

    for _ = 1, height do
        table.insert(marked_in_rows, 0)
    end

    local width = #(board[1])
    assert(width > 0)
    for _ = 1, width do
        table.insert(marked_in_columns, 0)
    end

    for i, row in ipairs(board) do
        assert(#row == width)

        for j, number in ipairs(row) do
            numbers_data[number] = { marked = false, position = { x = i, y = j } }

            numbers_sum = numbers_sum + number
        end
    end

    local self = {
        board = board,
        size = { width = width, height = height },
        numbers_data = numbers_data,
        numbers_sum = numbers_sum,
        marked_in_rows = marked_in_rows,
        marked_in_columns = marked_in_columns,
        marked_sum = 0,
        winning = false
    }

    return setmetatable(self, BingoBoard._mt)
end


local function parse_input(raw_input)
    local _, _, order_input, boards_input = string.find(raw_input, "(.-)\n\n(.+)")

    local marking_order = {}
    for number in string.gmatch(order_input, "(%d+)") do
        table.insert(marking_order, tonumber(number))
    end

    boards_input = string.gsub(boards_input, "\n\n", "\r")
    boards_input = string.gsub(boards_input, "\n", "\t")
    boards_input = string.gsub(boards_input, "\r", "\n")

    local boards = {}
    for board_input in string.gmatch(boards_input, "[^\n]+") do
        local board = {}
        for row_input in string.gmatch(board_input, "[^\t]+") do
            local row = {}
            for number in string.gmatch(row_input, "(%d+)") do
                table.insert(row, tonumber(number))
            end
            table.insert(board, row)
        end
        table.insert(boards, BingoBoard.new(board))
    end

    return { marking_order = marking_order, boards = boards }
end


local function part_one(input)
    input = parse_input(input)

    for _, number in ipairs(input.marking_order) do
        for _, board in ipairs(input.boards) do
            board:mark(number)

            if board.winning then
                return (board.numbers_sum - board.marked_sum) * number
            end
        end
    end

    error("First winning board not found")
end


local function part_two(input)
    input = parse_input(input)

    local board_left = #(input.boards)

    for _, number in ipairs(input.marking_order) do
        for _, board in ipairs(input.boards) do
            if not board.winning then
                board:mark(number)

                if board.winning then
                    board_left = board_left - 1
                end

                if board_left == 0 then
                    return (board.numbers_sum - board.marked_sum) * number
                end
            end
        end
    end

    error("Last winning board not found")
end


local PUZZLE = {
    year = 2021,
    day = 4
}

Utils.check(PUZZLE, part_one, 4512, Utils.read_raw)
Utils.run(PUZZLE, part_one, Utils.read_raw)

Utils.check(PUZZLE, part_two, 1924, Utils.read_raw)
Utils.run(PUZZLE, part_two, Utils.read_raw)
