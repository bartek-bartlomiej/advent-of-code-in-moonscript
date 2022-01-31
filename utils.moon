FILENAME = (extension, number, suffix="") -> string.format("%d/%02d%s.%s", number.year, number.day, suffix, extension)
EXAMPLE_FILENAME = (number, suffix="") -> FILENAME("example", number, suffix)
INPUT_FILENAME = (number) -> FILENAME("input", number)


solve = (part, filename) ->
    -- in YueScript:
    -- filename
        -- |> part.read
        -- |> part.parse
        -- |> part.solution
    
    -- in MoonScript:
    input = part.read(filename)
    data = part.parse(input)
    
    part.solution(data)
    

check = (part, test, puzzle_number) ->
    { number: test_number, result: expected_result } = test
    filename = EXAMPLE_FILENAME(puzzle_number, test_number)
    result = solve(part, filename)
    assert(result == expected_result, "Assertion failed, result is #{result}, expected #{expected_result}")


multicheck = (part, tests, puzzle_number) ->
    for number, result in pairs(tests)
        check(part, { :number, :result }, puzzle_number)


run_part = (part, puzzle_number) ->
    tests = part.tests
    switch type(tests)
        when "number"
            test = result: tests
            check(part, test, puzzle_number)
        else
            multicheck(part, tests, puzzle_number)
    
    solution = solve(part, INPUT_FILENAME(puzzle_number))
    print(solution)


run = (puzzle) ->
    { :number, :parts } = puzzle
    assert(number.year and number.day, "Puzzle number is missing")

    for part in *parts
        run_part(part, number)


read_raw = (filename) ->
    local input
    with file = io.open(filename, "r")
        assert(file, "File #{filename} not found")
        input = \read("a")
        \close!
    
    input


read_lines = (filename) -> [ line for line in io.lines(filename) ]


enable_string_indexing = () ->
    _mt = getmetatable("")
    __index = _mt.__index
    sub = string.sub

    _mt.__index = (str, key) ->
        if type(key) == "number"
            sub(str, key, key)
        else
            __index[key]


{ :run, :read_raw, :read_lines, :read_groups, :enable_string_indexing }
