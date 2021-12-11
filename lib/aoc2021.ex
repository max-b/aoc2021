defmodule Aoc2021 do
  @moduledoc """
  Documentation for `Aoc2021`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc2021.day()
      1215

  """

  def number_stream do
    filestream = File.stream!("data/day1-input1")
    replaced = Stream.map(filestream, fn x -> String.replace(x, "\n", "") end)

    numbered =
      Stream.map(replaced, fn x -> Integer.parse(x) end)
      |> Stream.filter(fn x -> tuple_size(x) == 2 end)
      |> Stream.map(fn x -> elem(x, 0) end)

    numbered
  end

  def day1_part1 do
    numbered = number_stream()
    zipped = Stream.zip(numbered, Stream.drop(numbered, 1))

    count =
      Enum.reduce(zipped, 0, fn x, acc ->
        if elem(x, 1) > elem(x, 0) do
          acc + 1
        else
          acc
        end
      end)

    count
  end

  def day1_part2 do
    numbered = number_stream()

    triplets =
      Stream.zip(numbered, Stream.drop(numbered, 1))
      |> Stream.zip(Stream.drop(numbered, 2))
      |> Stream.map(fn x -> [elem(elem(x, 0), 0), elem(elem(x, 0), 1), elem(x, 1)] end)

    triplets_summed = Stream.map(triplets, fn [x, y, z] -> x + y + z end)

    zipped = Stream.zip(triplets_summed, Stream.drop(triplets_summed, 1))

    count =
      Enum.reduce(zipped, 0, fn x, acc ->
        if elem(x, 1) > elem(x, 0) do
          acc + 1
        else
          acc
        end
      end)

    count
  end

  def day2_commands do
    filestream = File.stream!("data/day2-input1")

    Stream.map(filestream, fn x -> String.replace(x, "\n", "") end)
    |> Stream.map(fn x -> String.split(x, " ") end)
  end

  def day2_part1 do
    commands = day2_commands()

    pos =
      Enum.reduce(
        commands,
        [{:forward, 0}, {:depth, 0}],
        fn command, acc ->
          [direction, magnitude_string] = command
          [{:forward, forward}, {:depth, depth}] = acc
          magnitude = elem(Integer.parse(magnitude_string), 0)

          newpos =
            case direction do
              "forward" -> [{:forward, forward + magnitude}, {:depth, depth}]
              "down" -> [{:forward, forward}, {:depth, depth + magnitude}]
              "up" -> [{:forward, forward}, {:depth, depth - magnitude}]
            end

          newpos
        end
      )

    pos[:forward] * pos[:depth]
  end

  def day2_part2 do
    commands = day2_commands()

    pos =
      Enum.reduce(
        commands,
        [{:forward, 0}, {:depth, 0}, {:aim, 0}],
        fn command, acc ->
          [direction, magnitude_string] = command
          [{:forward, forward}, {:depth, depth}, {:aim, aim}] = acc
          magnitude = elem(Integer.parse(magnitude_string), 0)

          newpos =
            case direction do
              "down" ->
                [{:forward, forward}, {:depth, depth}, {:aim, aim + magnitude}]

              "up" ->
                [{:forward, forward}, {:depth, depth}, {:aim, aim - magnitude}]

              "forward" ->
                [{:forward, forward + magnitude}, {:depth, depth + aim * magnitude}, {:aim, aim}]
            end

          newpos
        end
      )

    pos[:forward] * pos[:depth]
  end
end
