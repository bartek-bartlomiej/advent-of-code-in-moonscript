local Utils = require("utils")


local function parse_line(line)
    local seat = line
    seat = string.gsub(seat, "B", "1")
    seat = string.gsub(seat, "F", "0")
    seat = string.gsub(seat, "R", "1")
    seat = string.gsub(seat, "L", "0")

    return tonumber(seat, 2)
end


local function part_one(input)
    local seat_IDs = Utils.parse_input(input, parse_line)

    local max_ID = -1
    for _, seat_ID in ipairs(seat_IDs) do
        if seat_ID > max_ID then
            max_ID = seat_ID
        end
    end

    return max_ID >= 0 and max_ID or nil
end


local function part_two(input)
    local seat_IDs = Utils.parse_input(input, parse_line)
    table.sort(seat_IDs)

    for i = 1, #seat_IDs - 1 do
        local current_ID, next_ID = seat_IDs[i], seat_IDs[i + 1]
        if next_ID - current_ID == 2 then
            return current_ID + 1
        end
    end

    return nil
end


local PUZZLE = {
    year = 2020,
    day = 5
}

Utils.check(PUZZLE, part_one, 820, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, nil, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
