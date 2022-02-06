Utils = require("src.utils")

{ :min, :max } = math 

class Polymer
    new: (template) =>
        element_pairs = {}
        for i = 1, #template - 1
            pair = template\sub(i, i + 1)
            element_pairs[pair] = (element_pairs[pair] or 0) + 1

        elements = {}
        for i = 1, #template
            element = template\sub(i, i)
            elements[element] = (elements[element] or 0) + 1

        @pairs = element_pairs
        @elements = elements

    
    progress: (insertions_rules) =>
        element_pairs = {}
        elements = { element, amount for element, amount in pairs(@elements) }

        for pair, amount in pairs(@pairs)
            rule = insertions_rules[pair]
            
            elements[rule.new_element] = (elements[rule.new_element] or 0) + amount
            for new_pair in *rule.new_pairs
                element_pairs[new_pair] = (element_pairs[new_pair] or 0) + amount
        
        @pairs = element_pairs
        @elements = elements


    get_extremes: () =>
        local minimum, maximum

        for _, amount in pairs(@elements)
            minimum = minimum and min(minimum, amount) or amount
            maximum = maximum and max(maximum, amount) or amount

        minimum, maximum

    
    dump: () =>
        for element, amount in pairs(@elements) do print(element, amount)
        for pair, amount in pairs(@pairs) do print(pair, amount)
        print()


parse_input = (input) ->
    parse_rule = (rule) ->
        first_element, second_element, new_element = rule\match("(%u)(%u) %-> (%u)")
        pair = first_element .. second_element

        pair, { 
            :new_element,
            new_pairs: { first_element .. new_element, new_element .. second_element }
        }

    template, rules = input\match("(%u+)\n\n(.+)")
    insertions_rules = { parse_rule(rule) for rule in rules\gmatch("[^\n]+") }

    { polymer: Polymer(template), :insertions_rules }


calculate_difference = (data, steps_amount) ->
    { :polymer, :insertions_rules } = data

    for _ = 1, steps_amount do polymer\progress(insertions_rules)
    minimum, maximum = polymer\get_extremes!

    maximum - minimum


part_one = (data) -> calculate_difference(data, 10)


part_two = (data) -> calculate_difference(data, 40)


parts:
    [1]:
        read: Utils.read_raw
        parse: parse_input
        solution: part_one
        tests: 1588
    [2]:
        read: Utils.read_raw
        parse: parse_input
        solution: part_two
        tests: 2188189693529
        