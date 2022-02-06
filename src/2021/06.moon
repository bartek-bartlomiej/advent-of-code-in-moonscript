Utils = require("src.utils")

SPAWN_CYCLE = 7
CHILDHOOD = 2


-- naive attempt
--
-- parse_input = (input) -> 
--    return for fish_input in input\gmatch("(%d)")
--        tonumber(fish_input) + 1 

-- simulate = (school, days) ->
--    for _ = 1, days
--        size = #school
--        for i = 1, size
--            fish = school[i] - 1
           
--            school[i] = if fish == 0
--                table.insert(school, SPAWN_CYCLE + CHILDHOOD)
--                SPAWN_CYCLE
--            else
--                fish

--    #school


-- better attempt

class School
    new: (input) =>
        for i = 1, SPAWN_CYCLE + CHILDHOOD
            @[i] = 0

        for age in input\gmatch("(%d)")
            fish = tonumber(age) + 1
            @[fish] += 1

    grow: () =>
        -- epoch's parents
        parents_amount = @[1]
        -- shift rest of school
        for i = 1, SPAWN_CYCLE + CHILDHOOD
            @[i] = @[i + 1]

        -- epoch's newborns
        @[SPAWN_CYCLE + CHILDHOOD] = parents_amount
        -- epoch's parents will wait 7 days before next spawn 
        @[SPAWN_CYCLE] += parents_amount

    count: () =>
        result = 0
        for amount in *@ do result += amount

        result


parse_input = (input) -> School(input)


simulate = (school, days) ->
    for _ = 1, days
        school\grow!
    
    school\count!


part_one = (school) ->
    simulate(school, 80)


part_two = (school) ->
    simulate(school, 256)


parts:
    [1]:
        read: Utils.read_raw
        parse: parse_input
        solution: part_one
        tests: 5934
    [2]:
        read: Utils.read_raw
        parse: parse_input
        solution: part_two
        tests: 26984457539
