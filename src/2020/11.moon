Utils = require("src.utils")


class Seat
    @TYPE:
        FLOOR: 0
        EMPTY: 1
        OCCUPIED: 2
    
    symbols =
        [@TYPE.FLOOR]: '.'
        [@TYPE.EMPTY]: 'L' 
        [@TYPE.OCCUPIED]: '#'
    
    mapping = { symbol, type for type, symbol in pairs(symbols) }

    new: (x, y, area, symbol) =>
        @x = x
        @y = y
        @area = area
        @type = mapping[symbol]

    
    __tostring: () => symbols[@type]

    
    change_type: (type) =>
        assert(@type ~= @@TYPE.FLOOR, "Floor should not be changed")
        
        if @type == type
            false
        else
            @type = type    
            true

    
    get_status: () =>
        return false, false if @type == @@TYPE.FLOOR

        occupied_neighbours = @_get_occupied_neighbours!
        
        @_should_be_free(occupied_neighbours), @_should_be_taken(occupied_neighbours)

    
    _get_occupied_neighbours: () =>
        occupied = {}
        for i = -1, 1
            x = @x + i
            continue unless 1 <= x and x <= @area.width

            for j = -1, 1
                y = @y + j
                continue unless 1 <= y and y <= @area.height

                neighbour = @area.seats[y][x]
                continue unless neighbour ~= @
                
                table.insert(occupied, neighbour) if neighbour.type == @@TYPE.OCCUPIED

        occupied

    _should_be_free: (occupied_neighbours) => #occupied_neighbours >= 4
    _should_be_taken: (occupied_neighbours) => #occupied_neighbours == 0


class AnotherSeat extends Seat
    directions = do
        d = {}
        for i = -1, 1
            for j = -1, 1
                continue if i == 0 and j == 0
                table.insert(d, { i, j })

        d

    _get_occupied_neighbours: () =>
        occupied = {}

        for direction in *directions
            { i, j } = direction
            
            x, y = @x + i, @y + j
            while true
                break unless 1 <= x and x <= @area.width
                break unless 1 <= y and y <= @area.height
                
                neighbour = @area.seats[y][x]
                if neighbour.type ~= @@TYPE.FLOOR
                    table.insert(occupied, neighbour) if neighbour.type == @@TYPE.OCCUPIED
                    break

                x += i
                y += j

        occupied

    _should_be_free: (occupied_neighbours) => #occupied_neighbours >= 5

    __tostring: () => super!
    

class WaitingArea

    progress = () =>
        to_occupy, to_free = {}, {}

        for row in *@seats
            for seat in *row
                should_be_free, should_be_taken = seat\get_status!

                table.insert(to_free, seat) if should_be_free
                table.insert(to_occupy, seat) if should_be_taken

        -- print(#to_free, #to_occupy)

        change_type = (t, type) ->
            were_changes = false
            while #t > 0
                seat = table.remove(t)

                changed = seat\change_type(type)
                were_changes = changed or were_changes 
            
            were_changes

        were_taken = change_type(to_occupy, Seat.TYPE.OCCUPIED)
        were_free = change_type(to_free, Seat.TYPE.EMPTY)

        not (were_taken or were_free)


    make_stable: () =>
        stable = false
        while not stable
            stable = progress(@)
            -- @dump!

    
    count_occupied: () =>
        count = 0
        for row in *@seats
            for seat in *row
                count += 1 if seat.type == Seat.TYPE.OCCUPIED

        count


    dump: () =>
        for row in *@seats
            s = ""
            for seat in *row do
                s = s .. tostring(seat)
            print(s)
        print()
    

    new: (symbols, Seat) =>
        height = #symbols
        assert(height > 0)

        width = #(symbols[1])
        assert(width > 0)
        
        seats = for j, row in ipairs(symbols)
            assert(#row == width)
            
            for i, symbol in ipairs(row)
                Seat(i, j, @, symbol)

        @width = width
        @height = height
        @seats = seats



parse_input = (input) -> [ [ character for character in row\gmatch("(.)") ] for row in *input ]


solution = (seat_class) ->
    (symbols) ->
        area = WaitingArea(symbols, seat_class)
        area\make_stable!

        area\count_occupied!


part_one = solution(Seat)
        

part_two = solution(AnotherSeat)


parts:
    [1]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_one
        tests: 37
    [2]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_two
        tests: 26
