local Utils = require("utils")

local OctopusGrid = {}
OctopusGrid.FLASH_LEVEL = 9
OctopusGrid.REST_LEVEL = 0

local Status = {
    CHARGING = 0,
    WILL_FLASH = 1,
    JUST_FLASHED = 2
}

local function progress(grid)
    local to_flash = {}
    local flashed = {}

    local function rise_energy(octopus)
        local updated_energy = octopus.energy + 1
        octopus.energy = updated_energy

        if octopus.status == Status.CHARGING and updated_energy > OctopusGrid.FLASH_LEVEL then
            octopus.status = Status.WILL_FLASH
            table.insert(to_flash, octopus)
        end
    end

    local function get_neighbours(octopus)
        local neighbours = {}
        for i = -1, 1 do
            local x = octopus.position.x + i
            if 1 <= x and x <= grid.width then
                for j = -1, 1 do
                    local y = octopus.position.y + j
                    if 1 <= y and y <= grid.height then
                        local neighbour = grid.octopuses[x][y]
                        if neighbour ~= octopus then
                            table.insert(neighbours, neighbour)
                        end
                    end
                end
            end
        end

        return neighbours
    end

    local function flash(octopus)
        if octopus.status == Status.JUST_FLASHED then
            return
        end

        octopus.status = Status.JUST_FLASHED
        table.insert(flashed, octopus)

        for _, neighbour in ipairs(get_neighbours(octopus)) do
            rise_energy(neighbour)
        end
    end

    -- step 1
    for _, row in ipairs(grid.octopuses) do
        for _, octopus in ipairs(row) do
            rise_energy(octopus)
        end
    end

    -- step 2
    while #to_flash > 0 do
        flash(table.remove(to_flash))
    end

    -- step 3
    local count = #flashed
    for _, octopus in ipairs(flashed) do
        octopus.energy = OctopusGrid.REST_LEVEL
        octopus.status = Status.CHARGING
    end

    return count
end


function OctopusGrid:simulate(epochs)
    local sum = 0
    for i = 1, epochs do
        local flashed = progress(self)
        sum = sum + flashed
        -- print(flashed)
        -- self:dump()
    end

    return sum
end


function OctopusGrid:find_epoch()
    local size = self.width * self.height
    local epoch = 0
    repeat
        epoch = epoch + 1
        local flashed = progress(self)
    until flashed == size

    return epoch
end


function OctopusGrid:dump()
    for _, row in ipairs(self.octopuses) do
        local s = ""
        for _, octopus in ipairs(row) do
            s = s .. octopus.energy
        end
        print(s)
    end
    print()
end


OctopusGrid._mt = { __index = OctopusGrid }

function OctopusGrid.new(numbers)
    local height = #numbers
    assert(height > 0)

    local width = #(numbers[1])
    assert(width > 0)

    local octopuses = {}
    for i, numbers_row in ipairs(numbers) do
        assert(#numbers_row == width)
        local row = {}
        for j, number in ipairs(numbers_row) do
            assert(OctopusGrid.REST_LEVEL <= number and number <= OctopusGrid.FLASH_LEVEL)
            row[j] = {
                energy = number,
                status = Status.CHARGING,
                position = { x = i, y = j }
            }
        end
        table.insert(octopuses, row)
    end

    local self = {
        width = width,
        height = height,
        octopuses = octopuses
    }
    return setmetatable(self, OctopusGrid._mt)
end


local function parse_input(input)
    local grid = {}
    for _, row_input in ipairs(input) do
        local row = {}
        for number in string.gmatch(row_input, "(%d)") do
            table.insert(row, tonumber(number))
        end
        table.insert(grid, row)
    end

    return OctopusGrid.new(grid)
end


local function part_one(input)
    local grid = parse_input(input)
    return grid:simulate(100)
end


local function part_two(input)
    local grid = parse_input(input)
    return grid:find_epoch()
end


local PUZZLE = {
    year = 2021,
    day = 11
}

Utils.check(PUZZLE, part_one, 1656, Utils.read_lines)
Utils.run(PUZZLE, part_one, Utils.read_lines)

Utils.check(PUZZLE, part_two, 195, Utils.read_lines)
Utils.run(PUZZLE, part_two, Utils.read_lines)
