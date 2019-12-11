defmodule Aoc.Year2019.Day11.SpacePolice do
  @moduledoc """
  ## --- Day 11: Space Police ---

  On the way to Jupiter, you're pulled over by the *Space Police*.

  "Attention, unmarked spacecraft! You are in violation of Space Law! All
  spacecraft must have a clearly visible *registration identifier*! You have 24
  hours to comply or be sent to Space Jail!"

  Not wanting to be sent to Space Jail, you radio back to the Elves on Earth for
  help. Although it takes almost three hours for their reply signal to reach you,
  they send instructions for how to power up the *emergency hull painting robot*
  and even provide a small Intcode program (your puzzle input) that will cause it
  to paint your ship appropriately.

  There's just one problem: you don't have an emergency hull painting robot.

  You'll need to build a new emergency hull painting robot. The robot needs to be
  able to move around on the grid of square panels on the side of your ship,
  detect the color of its current panel, and paint its current panel *black* or
  *white*. (All of the panels are currently *black*.)

  The Intcode program will serve as the brain of the robot. The program uses input
  instructions to access the robot's camera: provide `0` if the robot is over a
  *black* panel or `1` if the robot is over a *white* panel. Then, the program
  will output two values:

  - First, it will output a value indicating the *color to paint the panel* the robot is over: `0` means to paint the panel *black*, and `1` means to paint the panel *white*.
  - Second, it will output a value indicating the *direction the robot should turn*: `0` means it should turn *left 90 degrees*, and `1` means it should turn *right 90 degrees*.
  After the robot turns, it should always move *forward exactly one panel*. The
  robot starts facing *up*.

  The robot will continue running for a while like this and halt when it is
  finished drawing. Do not restart the Intcode computer inside the robot during
  this process.

  For example, suppose the robot is about to start running. Drawing black panels
  as `.`, white panels as `#`, and the robot pointing the direction it is facing
  (`< ^ > v`), the initial state and region near the robot looks like this:

  `.....
  .....
  ..^..
  .....
  .....
  `The panel under the robot (not visible here because a `^` is shown instead) is
  also black, and so any input instructions at this point should be provided `0`.
  Suppose the robot eventually outputs `1` (paint white) and then `0` (turn left).
  After taking these actions and moving forward one panel, the region now looks
  like this:

  `.....
  .....
  .<#..
  .....
  .....
  `Input instructions should still be provided `0`. Next, the robot might output
  `0` (paint black) and then `0` (turn left):

  `.....
  .....
  ..#..
  .v...
  .....
  `After more outputs (`1,0`, `1,0`):

  `.....
  .....
  ..^..
  .##..
  .....
  `The robot is now back where it started, but because it is now on a white panel,
  input instructions should be provided `1`. After several more outputs (`0,1`,
  `1,0`, `1,0`), the area looks like this:

  `.....
  ..<#.
  ...#.
  .##..
  .....
  `Before you deploy the robot, you should probably have an estimate of the area it
  will cover: specifically, you need to know the *number of panels it paints at
  least once*, regardless of color. In the example above, the robot painted *`6`
  panels* at least once. (It painted its starting panel twice, but that panel is
  still only counted once; it also never painted the panel it ended on.)

  Build a new emergency hull painting robot and run the Intcode program on it.
  *How many panels does it paint at least once?*


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

    run(computer) |> map_size()
  end

  def run(computer, direction \\ {0, -1}, position \\ {0, 0}, board \\ %{})
  def run(%IntcodeComputer{state: :halt}, _, _, board), do: board

  def run(computer, {dx, dy}, {x, y}, board) do
    pixel = Map.get(board, {x, y}, 0)
    computer = IntcodeComputer.feed(computer, [pixel])
    {computer, [color, turn]} = IntcodeComputer.consume(computer)
    board = Map.put(board, {x, y}, color)
    {dx, dy} = turn({dx, dy}, turn)
    {x, y} = {x + dx, y + dy}

    run(computer, {dx, dy}, {x, y}, board)
  end

  def turn({x, 0}, 0), do: {0, x * -1}
  def turn({x, 0}, 1), do: {0, x * 1}
  def turn({0, y}, 0), do: {y, 0}
  def turn({0, y}, 1), do: {y * -1, 0}

  @doc """

  """
  def part_2(input) do
    computer =
      input
      |> IntcodeComputer.parse()
      |> IntcodeComputer.init()
      |> IntcodeComputer.run()

    board = Map.put(%{}, {0, 0}, 1)
    board = run(computer, {0, -1}, {0, 0}, board)

    {{min_x, _}, {max_x, _}} = Map.keys(board) |> Enum.min_max_by(fn {x, _y} -> x end)
    {{_, min_y}, {_, max_y}} = Map.keys(board) |> Enum.min_max_by(fn {_x, y} -> y end)

    min_y..max_y
    |> Enum.map(&print_row(board, &1, min_x, max_x))
    |> Enum.join("\n")
  end

  def print_row(board, y, min_x, max_x) do
    min_x..max_x
    |> Enum.map(fn x -> char(Map.get(board, {x, y}, 0)) end)
    |> Enum.join("")
  end

  def char(0), do: " "
  def char(1), do: "#"
end
