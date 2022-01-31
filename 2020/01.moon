Utils = require("utils")


parse_input = (input) -> [ tonumber(number) for number in *input ]


part_one = (data) ->
    find_numbers = (list) ->
        assert(#list >= 2, "List does not contain at least 2 numbers")

        for i = 1, #list - 1
            for j = i + 1, #list
                n1, n2 = list[i], list[j]

                return n1, n2 if n1 + n2 == 2020

        error("Numbers not found")

    n1, n2 = find_numbers(data)

    n1 * n2


part_two = (data) ->
    find_numbers = (list) ->
        assert(#list >= 3, "List does not contain at least 3 numbers")
        
        for i = 1, #list - 2
            for j = i + 1, #list - 1
                for k = j + 1, #list
                    n1, n2, n3 = list[i], list[j], list[k]

                    return n1, n2, n3 if n1 + n2 + n3 == 2020
                        
        error("Numbers not found")

    n1, n2, n3 = find_numbers(data)

    n1 * n2 * n3


Utils.run
    number:
        year: 2020, 
        day: 1
    parts:
        [1]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_one
            tests: 514579
        [2]:
            read: Utils.read_lines
            parse: parse_input
            solution: part_two
            tests: 241861950
