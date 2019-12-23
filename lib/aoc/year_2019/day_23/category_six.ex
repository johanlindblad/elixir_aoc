defmodule Aoc.Year2019.Day23.CategorySix do
  @moduledoc """
  ## --- Day 23: Category Six ---

  The droids have finished repairing as much of the ship as they can. Their report
  indicates that this was a *Category 6* disaster - not because it was that bad,
  but because it destroyed the stockpile of Category 6 network cables as well as
  most of the ship's network infrastructure.

  You'll need to *rebuild the network from scratch*.

  The computers on the network are standard Intcode computers that communicate by
  sending *packets* to each other. There are `50` of them in total, each running a
  copy of the same *Network Interface Controller* (NIC) software (your puzzle
  input). The computers have *network addresses*`0` through `49`; when each
  computer boots up, it will request its network address via a single input
  instruction. Be sure to give each computer a unique network address.

  Once a computer has received its network address, it will begin doing work and
  communicating over the network by sending and receiving *packets*. All packets
  contain *two values* named `X` and `Y`. Packets sent to a computer are queued by
  the recipient and read in the order they are received.

  To *send* a packet to another computer, the NIC will use *three output
  instructions* that provide the *destination address* of the packet followed by
  its `X` and `Y` values. For example, three output instructions that provide the
  values `10`, `20`, `30` would send a packet with `X=20` and `Y=30` to the
  computer with address `10`.

  To *receive* a packet from another computer, the NIC will use an *input
  instruction*. If the incoming packet queue is *empty*, provide `-1`. Otherwise,
  provide the `X` value of the next packet; the computer will then use a second
  input instruction to receive the `Y` value for the same packet. Once both values
  of the packet are read in this way, the packet is removed from the queue.

  Note that these input and output instructions never block. Specifically, output
  instructions do not wait for the sent packet to be received - the computer might
  send multiple packets before receiving any. Similarly, input instructions do not
  wait for a packet to arrive - if no packet is waiting, input instructions should
  receive `-1`.

  Boot up all `50` computers and attach them to your network. *What is the `Y`
  value of the first packet sent to address `255`?*


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

    computers =
      0..49
      |> Enum.reduce(%{}, fn address, map ->
        computer =
          IntcodeComputer.feed(computer, [address])
          |> IntcodeComputer.run()

        Map.put(map, address, {computer, [], []})
      end)

    step(computers)
  end

  def step(computers) do
    {computers, nat} =
      Enum.reduce(0..49, {computers, nil}, fn address, {computers, nat} ->
        {computer, queue, out_queue} = Map.get(computers, address)

        computer = %{computer | inputs: computer.inputs ++ queue, state: :continue}
        queue = []

        computer =
          case IntcodeComputer.will_wait(computer) do
            true -> %{computer | inputs: [-1]}
            false -> computer
          end

        computer = IntcodeComputer.step(computer)

        case IntcodeComputer.consume(computer) do
          {computer, []} ->
            computers = Map.put(computers, address, {computer, [], out_queue})
            {computers, nat}

          {computer, [output]} ->
            out_queue = out_queue ++ [output]

            {out_queue, computers, nat} =
              case out_queue do
                [address, x, y] ->
                  nat =
                    case address do
                      255 -> y
                      _ -> nat
                    end

                  computers =
                    Map.update(computers, address, {nil, []}, fn {computer, queue, out_queue} ->
                      {computer, queue ++ [x, y], out_queue}
                    end)

                  {[], computers, nat}

                _ ->
                  {out_queue, computers, nat}
              end

            computers = Map.put(computers, address, {computer, queue, out_queue})
            {computers, nat}
        end
      end)

    case nat do
      nil -> step(computers)
      nat -> nat
    end
  end

  @doc """

  """
  def part_2(input) do
    computer =
      input
      |> IntcodeComputer.parse()
      |> IntcodeComputer.init()
      |> IntcodeComputer.run()

    computers =
      0..49
      |> Enum.reduce(%{}, fn address, map ->
        computer =
          IntcodeComputer.feed(computer, [address])
          |> IntcodeComputer.run()

        Map.put(map, address, {computer, [], [], 0})
      end)

    step2(computers, nil, 0, 0)
  end

  def step2(computers, nat, steps_before, idle_steps, last_nat_y \\ nil) do
    {computers, nat, idle} =
      Enum.reduce(0..49, {computers, nat, true}, fn address, {computers, nat, idle} ->
        {computer, queue, out_queue, ^steps_before} = Map.get(computers, address)

        computer = %{computer | inputs: computer.inputs ++ queue, state: :continue}
        queue = []

        {computer, idle} =
          case IntcodeComputer.will_wait(computer) do
            true -> {%{computer | inputs: [-1]}, idle}
            false -> {computer, idle}
          end

        computer = IntcodeComputer.step(computer)
        steps = steps_before + 1

        case IntcodeComputer.consume(computer) do
          {computer, []} ->
            computers = Map.put(computers, address, {computer, [], out_queue, steps})
            {computers, nat, idle}

          {computer, [output]} ->
            out_queue = out_queue ++ [output]

            {out_queue, computers, nat, idle} =
              case out_queue do
                [address, x, y] ->
                  nat = if address == 255, do: {x, y}, else: nat

                  computers =
                    if address == 255,
                      do: computers,
                      else:
                        Map.update(computers, address, {nil, []}, fn {computer, queue, out_queue,
                                                                      steps} ->
                          {computer, queue ++ [x, y], out_queue, steps}
                        end)

                  {[], computers, nat, false}

                _ ->
                  {out_queue, computers, nat, false}
              end

            computers = Map.put(computers, address, {computer, queue, out_queue, steps})
            {computers, nat, idle}
        end
      end)

    idle_steps = if idle, do: idle_steps + 1, else: 0

    {computers, idle_steps, dup, last_nat_y} =
      if idle_steps > 1000 && nat != nil do
        {x, y} = nat

        dup = last_nat_y == y

        computers =
          Map.update!(computers, 0, fn {computer, _queue, out_queue, steps} ->
            {computer, [x, y], out_queue, steps}
          end)

        {computers, 0, dup, y}
      else
        {computers, idle_steps, false, last_nat_y}
      end

    case dup do
      false -> step2(computers, nat, steps_before + 1, idle_steps, last_nat_y)
      true -> last_nat_y
    end
  end
end
