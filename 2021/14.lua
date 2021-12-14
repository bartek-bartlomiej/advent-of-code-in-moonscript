local Utils = require("utils")


local Polymer = {}

function Polymer.progress(polymer, insertions_rules)
    local element_pairs = {}
    local elements = {}

    for element, amount in pairs(polymer.elements) do
        elements[element] = amount
    end

    for pair, amount in pairs(polymer.pairs) do
        local rule = insertions_rules[pair]
        elements[rule.new_element] = (elements[rule.new_element] or 0) + amount
        for _, new_pair in ipairs(rule.new_pairs) do
            element_pairs[new_pair] = (element_pairs[new_pair] or 0) + amount
        end
    end

    return { pairs = element_pairs, elements = elements }
end


function Polymer.get_extremes(polymer)
    local elements = polymer.elements
    local min, max
    -- local sum = 0

    for _, amount in pairs(elements) do
        min = min and math.min(min, amount) or amount
        max = max and math.max(max, amount) or amount
        -- sum = sum + amount
    end

    -- print(min, max, sum)
    return min, max --, sum
end


function Polymer.dump(polymer)
    print()
    for element, amount in pairs(polymer.elements) do
        print(element, amount)
    end
    for pair, amount in pairs(polymer.pairs) do
        print(pair, amount)
    end
end


local function parse_input(input)
    local template, rules = string.match(input, "(%u+)\n\n(.+)")

    local insertions_rules = {}
    for rule in string.gmatch(rules, "[^\n]+") do
        local first_element, second_element, new_element = string.match(rule, "(%u)(%u) %-> (%u)")
        local pair = first_element .. second_element

        insertions_rules[pair] = {
            new_element = new_element,
            new_pairs =  {
                first_element .. new_element,
                new_element .. second_element
            }
          }
    end

    local elements_pairs = {}
    for i = 1, #template - 1 do
        local pair = string.sub(template, i, i+1)
        elements_pairs[pair] = (elements_pairs[pair] or 0) + 1
    end

    local elements = {}
    for i = 1, #template do
        local element = string.sub(template, i, i)
        elements[element] = (elements[element] or 0) + 1
    end

    return { pairs = elements_pairs, elements = elements }, insertions_rules
end


local function calculate_difference(input, steps_amount)
    local polymer, insertions_rules = parse_input(input)

    for _ = 1, steps_amount do
        polymer = Polymer.progress(polymer, insertions_rules)
    end

    local min, max = Polymer.get_extremes(polymer)
    return max - min
end


local function part_one(input)
    return calculate_difference(input, 10)
end


local function part_two(input)
    return calculate_difference(input, 40)
end


local PUZZLE = {
    year = 2021,
    day = 14
}

Utils.check(PUZZLE, part_one, 1588, Utils.read_raw)
Utils.run(PUZZLE, part_one, Utils.read_raw)

Utils.check(PUZZLE, part_two, 2188189693529, Utils.read_raw)
Utils.run(PUZZLE, part_two, Utils.read_raw)
