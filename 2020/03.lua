local Utils = require("utils")


local function count_trees(rows, slide)
    local TREE = "#"
    local trees_amount = 0

    local down = slide.down
    local right = slide.right

    local length = #(rows[1])
    local position_x = 1

    for position_y = 1, #rows, down do
        local row = rows[position_y]
        local char = row[position_x]

        if char == TREE then
            trees_amount = trees_amount + 1
        end

        position_x = (position_x + right) % length
        if position_x == 0 then
            position_x = length
        end
    end

    return trees_amount
end


local function part_one(input)
    return count_trees(input, { right = 3, down = 1 })
end


local function part_two(input)
    local slides = {
        { right = 1, down = 1 },
        { right = 3, down = 1 },
        { right = 5, down = 1 },
        { right = 7, down = 1 },
        { right = 1, down = 2 }
    }

    local results = {}
    for _, slide in pairs(slides) do
        table.insert(results, count_trees(input, slide))
    end

    local output = 1
    for _, result in pairs(results) do
        output = output * result
    end

    return output
end


Utils.enable_string_indexing()

local PUZZLE = {
    year = 2020,
    day = 3
}

Utils.check(PUZZLE, part_one, 7, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 336, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
