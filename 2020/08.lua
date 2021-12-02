local Utils = require("utils")


local Instructions = {}

Instructions.NAMES = {
    JMP = "jmp",
    NOP = "nop",
    ACC = "acc"
}

function Instructions.jmp(machine, value)
    machine.instruction_pointer = machine.instruction_pointer + value
    return machine:execute()
end


function Instructions.acc(machine, value)
    machine.accumulator = machine.accumulator + value
    return Instructions.jmp(machine, 1)
end


function Instructions.nop(machine, _)
    return Instructions.jmp(machine, 1)
end


local Machine = {}


Machine.STOP_OK = 1
Machine.STOP_LOOP = 2 


function Machine:execute()
    if self.instruction_pointer == self.stop_pointer then return Machine.STOP_OK end
    if self.run_map[self.instruction_pointer] then return Machine.STOP_LOOP end

    self.run_map[self.instruction_pointer] = true
    
    local instruction = self.instructions[self.instruction_pointer]
    return Instructions[instruction.operation](self, instruction.argument)
end


function Machine.new(instructions)
    local self = {
        instructions = instructions,
        stop_pointer = #instructions + 1,
        instruction_pointer = 1,
        accumulator = 0,
        run_map = {}
    }
    return setmetatable(self, { __index = Machine })
end


function parse_input(input)
    local pattern = "(%a%a%a) ([%+%-]%d+)"

    local instructions = {}
    for operation, argument in string.gmatch(input, pattern) do
        table.insert(instructions, { operation = operation, argument = tonumber(argument)})
    end

    return instructions
end


function part_one(input)
    local instructions = parse_input(input)

    local machine = Machine.new(instructions)
    local execute_result = machine:execute()
    assert(execute == STOP_LOOP)

    return machine.accumulator
end


function part_two(input)
    local instructions = parse_input(input)

    local machine = Machine.new(instructions)
    local execute_result = machine:execute()
    assert(execute == STOP_LOOP)

    local swapped_operations = {
        [Instructions.NAMES.NOP] = Instructions.NAMES.JMP,
        [Instructions.NAMES.JMP] = Instructions.NAMES.NOP
    }

    for i, _ in pairs(machine.run_map) do
        local instruction = instructions[i]
        local operation = instruction.operation
        local swapped_operation = swapped_operations[operation]

        if operation ~= Instructions.NAMES.ACC and 
            not (operation == Instructions.NAMES.NOP and instruction.argument == 0) then

            instructions[i].operation = swapped_operation

            local machine = Machine.new(instructions)
            local execute_result = machine:execute()

            if execute_result == Machine.STOP_OK then
                return machine.accumulator
            end

            instructions[i].operation = operation
        end        
    end

    error("Single swapping failed")
end


local PUZZLE = {
    year = 2020,
    day = 8
}

Utils.check(PUZZLE, part_one, 5, Utils.read_raw)
Utils.run(PUZZLE, part_one, Utils.read_raw)

Utils.check(PUZZLE, part_two, 8, Utils.read_raw)
Utils.run(PUZZLE, part_two, Utils.read_raw)
