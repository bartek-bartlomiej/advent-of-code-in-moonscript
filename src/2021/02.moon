Utils = require("src.utils")

ACTION_FORWARD = "forward"
ACTION_UP = "up"
ACTION_DOWN = "down"


parse_line = (line) -> 
    key, value = line\match("(%S+) (%d+)")
    { :key, :value }

parse_input = (input) -> [ parse_line(line) for line in *input ]


part_one = (actions) ->
    horizontal_position = 0
    depth = 0

    for action in *actions
        switch action.key
            when ACTION_FORWARD
                horizontal_position += action.value
            when ACTION_DOWN
                depth += action.value
            when ACTION_UP then
                depth -= action.value
            else
                error("Unknown action")

    math.floor(horizontal_position * depth)


part_two = (actions) ->
    HORIZONTAL = "horizontal"
    DEPTH = "depth"
    AIM = "aim"

    position = 
        [HORIZONTAL]: 0
        [DEPTH]: 0
        [AIM]: 0

    change = (key, value) ->
        position[key] += value

    callbacks =
        [ACTION_DOWN]: (v) -> change(AIM, v)
        [ACTION_UP]: (v) -> change(AIM, -v)
        [ACTION_FORWARD]: (v) ->
            change(HORIZONTAL, v)
            change(DEPTH, position[AIM] * v)

    for action in *actions
        callbacks[action.key](action.value)

    math.floor(position[HORIZONTAL] * position[DEPTH])


parts:
    [1]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_one
        tests: 150
    [2]:
        read: Utils.read_lines
        parse: parse_input
        solution: part_two
        tests: 900
