Utils = require("utils")


class Mask
    KEYS = "abcdefghijklmnopqrtsuvwxyz"

    new: (initial_value=false) =>
        @reset(initial_value)

    reset: (value) => for key in KEYS\gmatch(".") do @[key] = value


parse_input = (input) -> Utils.get_groups(input, true)


count_answers = (answers) ->
    count = 0
    for key, value in pairs(answers) do
        count += 1 if value

    count


sum_answers = (data) ->
    sum = 0
    for answers in *data
        sum += count_answers(answers)

    sum


get_group_answers = (group) ->
    answers = {}
    
    for person_answers in *group
        for answer in person_answers\gmatch(".")
            answers[answer] = true

    answers


part_one = (groups) ->
    sum_answers([ get_group_answers(group) for group in *groups ])


get_group_common_answers = (group) ->
    common_answers = Mask(true)
    mask = Mask()

    for person_answers in *group
        for answer in person_answers\gmatch(".")
            mask[answer] = true
        for key, value in pairs(mask)
            common_answers[key] = common_answers[key] and value
        mask\reset(false)

    common_answers


part_two = (groups) ->
    sum_answers([ get_group_common_answers(group) for group in *groups ])


Utils.run
    number:
        year: 2020, 
        day: 6
    parts:
        [1]:
            read: Utils.read_raw
            parse: parse_input
            solution: part_one
            tests: 11
        [2]:
            read: Utils.read_raw
            parse: parse_input
            solution: part_two
            tests: 6
