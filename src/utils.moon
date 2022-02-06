FILENAME = (extension, number, suffix="") -> string.format("input/%d/%02d%s.%s", number.year, number.day, suffix, extension)
EXAMPLE_FILENAME = (number, suffix="") -> FILENAME("example", number, suffix)
INPUT_FILENAME = (number) -> FILENAME("input", number)


solve = (part, filename, arguments) ->
    -- in YueScript:
    -- filename
        -- |> part.read
        -- |> part.parse
        -- |> part.solution
    
    -- in MoonScript:
    input = part.read(filename)
    data = part.parse(input)
    
    part.solution(data, arguments)
    

check = (part, test, puzzle_number) ->
    { number: test_number, result: expected_result, :arguments } = test
    filename = EXAMPLE_FILENAME(puzzle_number, test_number)
    result = solve(part, filename, arguments)
    assert(result == expected_result, "Assertion failed, result is #{result}, expected #{expected_result}")

   
multicheck = (part, tests, puzzle_number, tests_arguments, default_arguments) ->
    for number, result in pairs(tests)
        test_arguments = tests_arguments[number] or default_arguments
        check(part, { :number, :result, arguments: test_arguments }, puzzle_number)


run_part = (part, puzzle_number) ->
    local default_arguments, tests_arguments
    if part.arguments
        default_arguments = part.arguments.solution
        tests_arguments = part.arguments.tests

    tests = part.tests
    switch type(tests)
        when "table"
            multicheck(part, tests, puzzle_number, tests_arguments or {}, default_arguments)
        else
            test = result: tests, arguments: tests_arguments or default_arguments
            check(part, test, puzzle_number)
    
    solution = solve(part, INPUT_FILENAME(puzzle_number), default_arguments)
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


get_groups = (raw_input, keep_rows=false) ->
    row_separator = if keep_rows then "\t" else " "
    input = raw_input\gsub("\n\n", "\r")\gsub("\n", row_separator)\gsub("\r", "\n")
    
    return for group in input\gmatch("[^\n]+")
        [ row for row in group\gmatch("[^#{row_separator}]+") ]


enable_string_indexing = () ->
    _mt = getmetatable("")
    return if _mt.indexing_enabled

    __index = _mt.__index
    sub = string.sub

    _mt.__index = (str, key) ->
        if type(key) == "number"
            sub(str, key, key)
        else
            __index[key]
    _mt.indexing_enabled = true


{ :run, :read_raw, :read_lines, :get_groups, :enable_string_indexing }
