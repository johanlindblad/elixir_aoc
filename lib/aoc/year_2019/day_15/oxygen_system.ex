defmodule Aoc.Year2019.Day15.OxygenSystem do
  @moduledoc """
  ## --- Day 15: Oxygen System ---

  Out here in deep space, many things can go wrong. Fortunately, many of those
  things have indicator lights. Unfortunately, one of those lights is lit: the
  oxygen system for part of the ship has failed!

  According to the readouts, the oxygen system must have failed days ago after a
  rupture in oxygen tank two; that section of the ship was automatically sealed
  once oxygen levels went dangerously low. A single remotely-operated *repair
  droid* is your only option for fixing the oxygen system.

  The Elves' care package included an Intcode program (your puzzle input) that you
  can use to remotely control the repair droid. By running that program, you can
  direct the repair droid to the oxygen system and fix the problem.

  The remote control program executes the following steps in a loop forever:

  - Accept a *movement command* via an input instruction.
  - Send the movement command to the repair droid.
  - Wait for the repair droid to finish the movement operation.
  - Report on the *status* of the repair droid via an output instruction.
  Only four *movement commands* are understood: north (`1`), south (`2`), west
  (`3`), and east (`4`). Any other command is invalid. The movements differ in
  direction, but not in distance: in a long enough east-west hallway, a series of
  commands like `4,4,4,4,3,3,3,3` would leave the repair droid back where it
  started.

  The repair droid can reply with any of the following *status* codes:

  - `0`: The repair droid hit a wall. Its position has not changed.
  - `1`: The repair droid has moved one step in the requested direction.
  - `2`: The repair droid has moved one step in the requested direction; its new position is the location of the oxygen system.
  You don't know anything about the area around the repair droid, but you can
  figure it out by watching the status codes.

  For example, we can draw the area using `D` for the droid, `#` for walls, `.`
  for locations the droid can traverse, and empty space for unexplored locations.
  Then, the initial state looks like this:

  `

     D


  `To make the droid go north, send it `1`. If it replies with `0`, you know that
  location is a wall and that the droid didn't move:

  `
     #
     D


  `To move east, send `4`; a reply of `1` means the movement was successful:

  `
     #
     .D


  `Then, perhaps attempts to move north (`1`), south (`2`), and east (`4`) are all
  met with replies of `0`:

  `
     ##
     .D#
      #

  `Now, you know the repair droid is in a dead end. Backtrack with `3` (which you
  already know will get a reply of `1` because you already know that location is
  open):

  `
     ##
     D.#
      #

  `Then, perhaps west (`3`) gets a reply of `0`, south (`2`) gets a reply of `1`,
  south again (`2`) gets a reply of `0`, and then west (`3`) gets a reply of `2`:

  `
     ##
    #..#
    D.#
     #
  `Now, because of the reply of `2`, you know you've found the *oxygen system*! In
  this example, it was only `*2*` moves away from the repair droid's starting
  position.

  *What is the fewest number of movement commands* required to move the repair
  droid from its starting position to the location of the oxygen system?


  """
  @wall 0
  @open 1
  @system 2
  @oxygen 3

  alias Aoc.Year2019.IntcodeComputer

  @doc """

  """
  def part_1(input) do
    computer =
      input
      |> IntcodeComputer.parse()
      |> IntcodeComputer.init()
      |> IntcodeComputer.run()

    {_maze, _system, steps} = bfs_discover([{{0, 0}, 0, computer, @open}], %{{0, 0} => @open})

    steps
  end

  def bfs_discover(queue, maze, system \\ nil)

  def bfs_discover([], maze, _system = {{x, y}, steps}) do
    {maze, {x, y}, steps}
  end

  def bfs_discover([{{x, y}, steps, computer, _tile} | rest], maze, system) do
    {maze, queue, system} =
      [1, 2, 3, 4]
      |> Enum.reject(&Map.has_key?(maze, move({x, y}, &1)))
      |> Enum.reduce({maze, rest, system}, fn direction, {maze, queue, system} ->
        {computer, [status]} =
          IntcodeComputer.feed(computer, [direction]) |> IntcodeComputer.consume()

        case status do
          @wall ->
            maze = Map.put(maze, move({x, y}, direction), @wall)
            {maze, queue, system}

          tile ->
            {x, y} = move({x, y}, direction)
            maze = Map.put(maze, {x, y}, tile)
            queue = queue ++ [{{x, y}, steps + 1, computer, tile}]
            system = if tile == @system, do: {{x, y}, steps + 1}, else: system
            {maze, queue, system}
        end
      end)

    bfs_discover(queue, maze, system)
  end

  defp effect(1), do: {0, -1}
  defp effect(2), do: {0, 1}
  defp effect(3), do: {-1, 0}
  defp effect(4), do: {1, 0}

  defp move({x, y}, direction) do
    {dx, dy} = effect(direction)
    {x + dx, y + dy}
  end

  @doc """

  """
  def part_2(input) do
    computer =
      input
      |> IntcodeComputer.parse()
      |> IntcodeComputer.init()
      |> IntcodeComputer.run()

    {maze, _system = {x, y}, _steps} =
      bfs_discover([{{0, 0}, 0, computer, @open}], %{{0, 0} => @open})

    maze
    |> Map.put({x, y}, @oxygen)
    |> Enum.filter(fn {_, tile} -> tile == @open || tile == @oxygen end)
    |> Map.new()
    |> oxygen_time
  end

  def oxygen_time(maze, time \\ 1) do
    expanded =
      Enum.reduce(Map.keys(maze), maze, fn {x, y}, new_maze ->
        case maze[{x, y}] do
          @oxygen ->
            new_maze

          @open ->
            adjacent = [1, 2, 3, 4] |> Enum.map(&move({x, y}, &1))

            fills =
              Enum.any?(adjacent, fn {x, y} ->
                Map.get(maze, {x, y}) == @oxygen
              end)

            case fills do
              true ->
                Map.put(new_maze, {x, y}, @oxygen)

              false ->
                new_maze
            end
        end
      end)

    left = Map.values(expanded) |> Enum.any?(fn tile -> tile == @open end)

    case left do
      true -> oxygen_time(expanded, 1 + time)
      false -> time
    end
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
    |> Enum.map(fn x ->
      Map.get(board, {x, y}, @wall) |> char
    end)
    |> Enum.join("")
  end

  def char(1), do: " "
  def char(0), do: "█"
  def char(2), do: "@"
  def char(nil), do: "█"

  def char(char), do: char
end
