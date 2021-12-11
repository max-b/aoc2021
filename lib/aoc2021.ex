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
end
