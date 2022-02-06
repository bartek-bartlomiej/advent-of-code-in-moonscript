Utils = require("src.utils")


class OctopusGrid
    @FLASH_LEVEL: 9
    @REST_LEVEL: 0
    @STATUS:
        CHARGING: 0
        WILL_FLASH: 1
        JUST_FLASHED: 2

    progress = (@) ->
        to_flash, flashed = {}, {}

        rise_energy = (octopus) ->
            updated_energy = octopus.energy + 1
            octopus.energy = updated_energy

            if octopus.status == @@STATUS.CHARGING and updated_energy > @@FLASH_LEVEL
                octopus.status = @@STATUS.WILL_FLASH
                table.insert(to_flash, octopus)

        
        get_neighbours = (octopus) ->
            neighbours = {}
            for i = -1, 1
                x = octopus.position.x + i
                continue unless 1 <= x and x <= @width

                for j = -1, 1
                    y = octopus.position.y + j
                    continue unless 1 <= y and y <= @height
                        
                    neighbour = @octopuses[x][y]
                    continue if neighbour == octopus
                    
                    table.insert(neighbours, neighbour)

            neighbours

        
        flash = (octopus) ->
            return if octopus.status == @@STATUS.JUST_FLASHED

            octopus.status = @@STATUS.JUST_FLASHED
            table.insert(flashed, octopus)

            for neighbour in *get_neighbours(octopus)
                rise_energy(neighbour)

        
        -- step 1
        for row in *@octopuses
            for octopus in *row
                rise_energy(octopus)

        -- step 2
        while #to_flash > 0
            flash(table.remove(to_flash))

        -- step 3
        local count = #flashed
        for octopus in *flashed do
            octopus.energy = @@REST_LEVEL
            octopus.status = @@STATUS.CHARGING
            
        count


    new: (numbers) =>
        height = #numbers
        assert(height > 0)

        width = #(numbers[1])
        assert(width > 0)
        
        octopuses = for i, numbers_row in ipairs(numbers)
            assert(#numbers_row == width)
            
            for j, number in ipairs(numbers_row)
                assert(@@REST_LEVEL <= number and number <= @@FLASH_LEVEL)
                
                { energy: number, status: @@STATUS.CHARGING, position: { x: i, y: j } }

        @width = width
        @height = height
        @octopuses = octopuses


    dump: () =>
        for row in *@octopuses
            s = ""
            for octopus in *row do
                s = s .. octopus.energy
        
            print(s)
    
        print()


    simulate: (epochs) =>
        sum = 0
        for i = 1, epochs
            flashed = progress(@)
            sum += flashed

        sum


    find_epoch: () =>
        size = @width * @height
        epoch, flashed = 0, 0
        
        while flashed ~= size
            epoch = epoch + 1
            flashed = progress(@)

        epoch
        

parse_input = (input) ->
    numbers = for row in *input
        [ tonumber(number) for number in row\gmatch("(%d)") ]
    
    OctopusGrid(numbers)


part_one = (grid) -> grid\simulate(100)


part_two = (grid) -> grid\find_epoch!


parts:
    [1]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_one
        tests: 1656
    [2]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_two
        tests: 195
