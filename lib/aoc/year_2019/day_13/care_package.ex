defmodule Aoc.Year2019.Day13.CarePackage do
  @moduledoc """
  ## --- Day 13: Care Package ---

  As you ponder the solitude of space and the ever-increasing three-hour roundtrip
  for messages between you and Earth, you notice that the Space Mail Indicator
  Light is blinking. To help keep you sane, the Elves have sent you a care
  package.

  It's a new game for the ship's arcade cabinet! Unfortunately, the arcade is *all
  the way* on the other end of the ship. Surely, it won't be hard to build your
  own - the care package even comes with schematics.

  The arcade cabinet runs Intcode software like the game the Elves sent (your
  puzzle input). It has a primitive screen capable of drawing square *tiles* on a
  grid. The software draws tiles to the screen with output instructions: every
  three output instructions specify the `x` position (distance from the left), `y`
  position (distance from the top), and `tile id`. The `tile id` is interpreted as
  follows:

  - `0` is an *empty* tile.  No game object appears in this tile.
  - `1` is a *wall* tile.  Walls are indestructible barriers.
  - `2` is a *block* tile.  Blocks can be broken by the ball.
  - `3` is a *horizontal paddle* tile.  The paddle is indestructible.
  - `4` is a *ball* tile.  The ball moves diagonally and bounces off objects.
  For example, a sequence of output values like `1,2,3,6,5,4` would draw a
  *horizontal paddle* tile (`1` tile from the left and `2` tiles from the top) and
  a *ball* tile (`6` tiles from the left and `5` tiles from the top).

  Start the game. *How many block tiles are on the screen when the game exits?*


  """

  alias Aoc.Year2019.IntcodeComputer

  @doc """

  """
  def part_1(input) do
    computer =
      input
      |> IntcodeComputer.parse()
      |> IntcodeComputer.init()
      |> IntcodeComputer.run()

    {computer, outputs} = IntcodeComputer.consume(computer)

    # run(computer, outputs) |> to_s |> IO.puts()
    run(computer, outputs) |> Map.values() |> Enum.filter(fn x -> x == 2 end) |> Enum.count()
  end

  def run(computer, outputs, board \\ %{})
  def run(_computer, [], board), do: board

  def run(computer, [x, y, tile | rest], board) do
    board = Map.put(board, {x, y}, tile)

    run(computer, rest, board)
  end

  @doc """

  """
  def part_2(input) do
    program =
      input
      |> IntcodeComputer.parse()

    [_ | program] = program

    computer =
      [2 | program]
      |> IntcodeComputer.init()
      |> IntcodeComputer.run()

    {computer, outputs} = IntcodeComputer.consume(computer)

    initial_board = run(computer, outputs)

    game(computer, initial_board)
  end

  def game(computer, board) do
    # board |> to_s |> IO.puts()

    {{px, _py}, 3} = board |> Enum.find(fn {_, c} -> c == 3 end)
    {{bx, _by}, 4} = board |> Enum.find(fn {_, c} -> c == 4 end)

    # IO.inspect("px: #{px}")

    input =
      case px - bx do
        0 -> 0
        d when d > 0 -> -1
        d when d < 0 -> 1
      end

    computer = IntcodeComputer.feed(computer, [input])
    {computer, outputs} = IntcodeComputer.consume(computer)

    {board, score} = handle(outputs, board, 0)

    # IO.puts("score: #{score}")

    # board = board |> Map.put(pos, 0) |> Map.put({x, y}, 4)

    cond do
      computer.state == :halt -> score
      true -> game(computer, board)
    end
  end

  def handle([], board, score), do: {board, score}

  def handle([-1, 0, score | rest], board, _) do
    handle(rest, board, score)
  end

  def handle([x, y, block | rest], board, score) do
    board = board |> Map.put({x, y}, block)
    handle(rest, board, score)
  end

  def to_s(board) do
    {{min_x, _}, {max_x, _}} = Map.keys(board) |> Enum.min_max_by(fn {x, _y} -> x end)
    {{_, min_y}, {_, max_y}} = Map.keys(board) |> Enum.min_max_by(fn {_x, y} -> y end)

    "\n" <>
      (min_y..max_y
       |> Enum.map(&print_row(board, &1, min_x, max_x))
       |> Enum.join("\n"))
  end

  def print_row(board, y, min_x, max_x) do
    min_x..max_x
    |> Enum.map(fn x -> char(Map.get(board, {x, y}, 0)) end)
    |> Enum.join("")
  end

  def char(0), do: " "
  def char(1), do: "█"
  def char(2), do: "-"
  def char(3), do: "="
  def char(4), do: "*"
end
