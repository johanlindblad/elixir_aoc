defmodule Aoc.Year2019.IntcodeComputer do
  alias Aoc.Year2019.IntcodeComputer
  defstruct memory: %{}, pc: 0, offset: 0, state: :continue, inputs: [], outputs: []

  def parse(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def init(program, inputs \\ []) when is_list(program) do
    memory =
      program
      |> Enum.with_index()
      |> Map.new(fn {x, y} -> {y, x} end)

    %IntcodeComputer{memory: memory, inputs: inputs, state: :continue}
  end

  def run(computer = %{state: :continue}) do
    run(step(computer))
  end

  def run(computer), do: computer

  def step(computer = %IntcodeComputer{state: :continue}) do
    {opcode, modes} = read_instruction(computer)
    ops = read_operands(computer)

    case opcode do
      1 -> arithmetic(computer, ops, modes, &Kernel.+/2)
      2 -> arithmetic(computer, ops, modes, &Kernel.*/2)
      3 -> input(computer, ops, modes)
      4 -> output(computer, ops, modes)
      5 -> jump_if(computer, ops, modes, true)
      6 -> jump_if(computer, ops, modes, false)
      7 -> arithmetic(computer, ops, modes, &Kernel.</2)
      8 -> arithmetic(computer, ops, modes, &Kernel.==/2)
      9 -> offset(computer, ops, modes)
      99 -> %{computer | state: :halt}
    end
  end

  def feed(computer = %{inputs: [], state: :waiting}, []), do: computer

  def feed(computer = %{inputs: []}, inputs) do
    %{computer | inputs: inputs, state: :continue} |> run
  end

  def consume(computer = %{outputs: outputs}), do: {%{computer | outputs: []}, outputs}

  def arithmetic(
        computer = %{memory: memory, offset: offset, pc: pc},
        {opa, opb, opc},
        {mode1, mode2, mode3},
        operator
      ) do
    sum = operator.(read(memory, opa, mode1, offset), read(memory, opb, mode2, offset)) |> to_i

    %{computer | memory: write(memory, opc, mode3, offset, sum), pc: pc + 4}
  end

  def input(computer = %{memory: memory, offset: offset, pc: pc}, {opa, _, _}, {mode1, _, _}) do
    case computer.inputs do
      [input | inputs] ->
        %{computer | memory: write(memory, opa, mode1, offset, input), inputs: inputs, pc: pc + 2}

      [] ->
        %{computer | state: :waiting}
    end
  end

  def output(
        computer = %{memory: memory, offset: offset, outputs: outputs, pc: pc},
        {opa, _, _},
        {mode1, _, _}
      ) do
    value = read(memory, opa, mode1, offset)
    %{computer | outputs: outputs ++ [value], pc: pc + 2}
  end

  def jump_if(
        computer = %{memory: memory, offset: offset, pc: pc},
        {opa, opb, _},
        {mode1, mode2, _},
        value
      ) do
    pc =
      case read(memory, opa, mode1, offset) != 0 do
        ^value -> read(memory, opb, mode2, offset)
        _ -> pc + 3
      end

    %{computer | pc: pc}
  end

  def offset(
        computer = %{memory: memory, offset: offset, pc: pc},
        {opa, _, _},
        {mode1, _, _}
      ) do
    %{computer | offset: offset + read(memory, opa, mode1, offset), pc: pc + 2}
  end

  defp read_instruction(%IntcodeComputer{pc: pc, memory: memory}) do
    instruction = read(memory, pc, 0, 0)

    opcode = rem(instruction, 100)

    [mode1, mode2, mode3] =
      [100, 1000, 10000]
      |> Enum.map(&(div(instruction, &1) |> rem(10)))

    {opcode, {mode1, mode2, mode3}}
  end

  defp read_operands(%IntcodeComputer{memory: memory, pc: pc}) do
    1..3 |> Enum.map(&Map.get(memory, pc + &1)) |> List.to_tuple()
  end

  defp read(memory, address, 0, _) when address >= 0 do
    Map.get(memory, address, 0)
  end

  defp read(_memory, address, 1, _), do: address

  defp read(memory, address, 2, offset) when address + offset >= 0 do
    Map.get(memory, address + offset, 0)
  end

  defp write(memory, address, mode, offset, value)

  defp write(memory, address, 0, _, value) when address >= 0 do
    Map.put(memory, address, value)
  end

  defp write(memory, address, 2, offset, value) when address + offset >= 0 do
    Map.put(memory, address + offset, value)
  end

  def to_i(true), do: 1
  def to_i(false), do: 0
  def to_i(other), do: other
end
