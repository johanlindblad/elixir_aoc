defmodule Aoc.Year2019.Day25.Cryostasis do
  @moduledoc """
  ## --- Day 25: Cryostasis ---

  As you approach Santa's ship, your sensors report two important details:

  First, that you might be too late: the internal temperature is `-40` degrees.

  Second, that one faint life signature is somewhere on the ship.

  The airlock door is locked with a code; your best option is to send in a small
  droid to investigate the situation. You attach your ship to Santa's, break a
  small hole in the hull, and let the droid run in before you seal it up again.
  Before your ship starts freezing, you detach your ship and set it to
  automatically stay within range of Santa's ship.

  This droid can follow basic instructions and report on its surroundings; you can
  communicate with it through an Intcode program (your puzzle input) running on an
  ASCII-capable computer.

  As the droid moves through its environment, it will describe what it encounters.
  When it says `Command?`, you can give it a single instruction terminated with a
  newline (ASCII code `10`). Possible instructions are:

  - *Movement* via `north`, `south`, `east`, or `west`.
  - To *take* an item the droid sees in the environment, use the command `take <name of item>`. For example, if the droid reports seeing a `red ball`, you can pick it up with `take red ball`.
  - To *drop* an item the droid is carrying, use the command `drop <name of item>`. For example, if the droid is carrying a `green ball`, you can drop it with `drop green ball`.
  - To get a *list of all of the items* the droid is currently carrying, use the command `inv` (for "inventory").
  Extra spaces or other characters aren't allowed - instructions must be provided
  precisely.

  Santa's ship is a *Reindeer-class starship*; these ships use pressure-sensitive
  floors to determine the identity of droids and crew members. The standard
  configuration for these starships is for all droids to weigh exactly the same
  amount to make them easier to detect. If you need to get past such a sensor, you
  might be able to reach the correct weight by carrying items from the
  environment.

  Look around the ship and see if you can find the *password for the main
  airlock*.


  """
  alias Aoc.Year2019.IntcodeComputer

  @initial "west
west
west
take coin
east
east
east
north
north
take mutex
east
take antenna
west
south
east
take cake
east
north
take pointer
south
west
west
south
east
east
take tambourine
east
take fuel cell
east
take boulder
north
inv
"

  @doc """

  """
  def part_1(input) do
    computer =
      input
      |> IntcodeComputer.parse()
      |> IntcodeComputer.init()
      |> IntcodeComputer.run()

    # manual(computer)
    # run(computer, cmds)
    attempt(computer)
  end

  def attempt(computer) do
    computer = IntcodeComputer.feed(computer, @initial |> String.graphemes())
    {computer, _output} = IntcodeComputer.consume(computer)

    inner_attempt(computer)
  end

  @items ["antenna", "boulder", "cake", "coin", "fuel cell", "mutex", "pointer", "tambourine"]
  def inner_attempt(computer) do
    0..255
    |> Enum.map(fn i -> i + 256 end)
    |> Enum.map(&Integer.digits(&1, 2))
    |> Enum.map(fn ds -> Enum.drop(ds, 1) end)
    |> Enum.find_value(fn ds ->
      to_drop =
        Enum.zip(@items, ds) |> Enum.filter(fn {_i, d} -> d == 1 end) |> Enum.map(&elem(&1, 0))

      cmd = to_drop |> Enum.map(fn i -> "drop #{i}" end) |> Enum.join("\n")
      cmd = "#{cmd}\neast\neast"

      computer = IntcodeComputer.feed(computer, cmd |> String.graphemes())
      {_c, output} = IntcodeComputer.run(computer) |> IntcodeComputer.consume()
      output = List.to_string(output)

      cond do
        String.contains?(output, ["heavier"]) ->
          nil

        String.contains?(output, ["lighter"]) ->
          nil

        true ->
          Regex.run(~r{typing ([0-9]+) on}, output)
          |> Enum.at(1)
          |> String.to_integer()
      end
    end)
  end

  def run(_computer, []), do: nil

  def run(computer, [cmd | rest]) do
    {computer, output} = IntcodeComputer.consume(computer)
    output = List.to_string(output)

    IO.puts(output)

    computer = IntcodeComputer.feed(computer, cmd |> String.graphemes())
    run(computer, rest)
  end

  def manual(computer) do
    {computer, output} = IntcodeComputer.consume(computer)
    output = List.to_string(output)

    IO.puts(output)

    cmd = IO.gets("command? ")

    computer = IntcodeComputer.feed(computer, cmd |> String.graphemes())
    manual(computer)
  end
end
