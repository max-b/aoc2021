defmodule Day1 do
  def number_stream do
    filestream = File.stream!("data/day1-input1")
    replaced = Stream.map(filestream, fn x -> String.replace(x, "\n", "") end)

    numbered =
      Stream.map(replaced, fn x -> Integer.parse(x) end)
      |> Stream.filter(fn x -> tuple_size(x) == 2 end)
      |> Stream.map(fn {first, _} -> first end)

    numbered
  end

  def part1 do
    numbered = number_stream()
    zipped = Stream.zip(numbered, Stream.drop(numbered, 1))

    count =
      Enum.reduce(zipped, 0, fn x, acc ->
        {first, second} = x

        if second > first do
          acc + 1
        else
          acc
        end
      end)

    count
  end

  def part2 do
    numbered = number_stream()

    triplets =
      Stream.zip(numbered, Stream.drop(numbered, 1))
      |> Stream.zip(Stream.drop(numbered, 2))
      |> Stream.map(fn {{x, y}, z} -> [x, y, z] end)

    triplets_summed = Stream.map(triplets, fn [x, y, z] -> x + y + z end)

    zipped = Stream.zip(triplets_summed, Stream.drop(triplets_summed, 1))

    count =
      Enum.reduce(zipped, 0, fn x, acc ->
        {first, second} = x

        if second > first do
          acc + 1
        else
          acc
        end
      end)

    count
  end
end
