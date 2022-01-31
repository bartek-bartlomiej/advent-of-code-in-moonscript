Utils = require("utils")

class Machine
    @ReturnValue = 
        STOP_OK: 1
        STOP_LOOP: 2

    @Instructions = 
        JMP: "jmp",
        NOP: "nop",
        ACC: "acc"

    Instructions = do
        jmp = (machine, value) ->
            machine.instruction_pointer += value
            
            machine\execute!
        
        acc = (machine, value) ->
            machine.accumulator += value
            
            jmp(machine, 1)
        
        nop = (machine, _) -> 
            jmp(machine, 1)

        { :jmp, :acc, :nop }

        
    new: (instructions) =>
        @instructions = instructions
        @stop_pointer = #instructions + 1
        @instruction_pointer = 1
        @accumulator = 0
        @run_map = {}

    execute: () =>
        return @@ReturnValue.STOP_OK if @instruction_pointer == @stop_pointer
        return @@ReturnValue.STOP_LOOP if @run_map[@instruction_pointer]

        @run_map[self.instruction_pointer] = true

        instruction = @instructions[@instruction_pointer]
        
        Instructions[instruction.operation](@, instruction.argument)

    get_run_map: () => pairs(@run_map)

    get_accumulator: () => @accumulator


INSTRUCTION_PATTERN = "(%a%a%a) ([%+%-]%d+)"

parse_input = (input) -> 
    return for operation, argument in string.gmatch(input, INSTRUCTION_PATTERN)
        { :operation, argument: tonumber(argument) }


part_one = (instructions) ->
    machine = Machine(instructions)
    execute_result = machine\execute!
    assert(execute_result == Machine.ReturnValue.STOP_LOOP)

    machine\get_accumulator!


part_two = (instructions) ->
    machine = Machine(instructions)
    execute_result = machine\execute!
    assert(execute_result == Machine.ReturnValue.STOP_LOOP)

    swapped_operations =
        [Machine.Instructions.NOP]: Machine.Instructions.JMP
        [Machine.Instructions.JMP]: Machine.Instructions.NOP

    for i, _ in machine\get_run_map!
        instruction = instructions[i]
        operation = instruction.operation
        swapped_operation = swapped_operations[operation]

        continue if operation == Machine.Instructions.ACC or
            (operation == Machine.Instructions.NOP and instruction.argument == 0)

        instructions[i].operation = swapped_operation

        fixed_machine = Machine(instructions)
        fixed_execute_result = fixed_machine\execute!

        return fixed_machine\get_accumulator! if fixed_execute_result == Machine.ReturnValue.STOP_OK
            
        instructions[i].operation = operation
        
    error("Single swapping failed")


Utils.run
    number:
        year: 2020, 
        day: 8
    parts:
        [1]:
            read: Utils.read_raw
            parse: parse_input
            solution: part_one
            tests: 5
        [2]:
            read: Utils.read_raw
            parse: parse_input
            solution: part_two
            tests: 8
