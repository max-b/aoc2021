defmodule Day7 do
  def get_input do
    input = File.read!("data/day7")

    positions =
      String.split(input, ",")
      |> Enum.map(fn i ->
        {x, _} = Integer.parse(i)
        x
      end)

    positions
  end

  def part1 do
    inputs = get_input()
    max = Enum.max(inputs)
    possibilities = 0..max

    cost_map =
      Enum.map(possibilities, fn possibility ->
        o = %{
          :possibility => possibility,
          :cost => Enum.reduce(inputs, 0, fn elem, acc -> acc + abs(elem - possibility) end)
        }

        o
      end)

    best_option = Enum.min_by(cost_map, fn %{:possibility => _, :cost => cost} -> cost end)

    best_option.cost
  end

  def sum_of_n(n) do
    Integer.floor_div(n * (n + 1), 2)
  end

  def part2 do
    inputs = get_input()
    max = Enum.max(inputs)
    possibilities = 0..max

    cost_map =
      Enum.map(possibilities, fn possibility ->
        o = %{
          :possibility => possibility,
          :cost =>
            Enum.reduce(inputs, 0, fn elem, acc -> acc + sum_of_n(abs(elem - possibility)) end)
        }

        o
      end)

    best_option = Enum.min_by(cost_map, fn %{:possibility => _, :cost => cost} -> cost end)

    best_option.cost
  end
end
