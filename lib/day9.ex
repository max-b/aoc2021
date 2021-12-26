defmodule Day9 do
  def get_grid do
    File.stream!("data/day9")
    |> Stream.map(fn x -> String.replace(x, "\n", "") end)
    |> Stream.map(fn x ->
      String.graphemes(x)
      |> Enum.map(fn x -> elem(Integer.parse(x), 0) end)
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, i}, acc ->
      Enum.reduce(Enum.with_index(row), acc, fn {cell, j}, acc ->
        Map.merge(acc, %{{i, j} => cell})
      end)
    end)
  end

  def part1 do
    grid = get_grid()

    Enum.reduce(grid, 0, fn {{i, j}, val}, acc ->
      IO.inspect({i, j, val})
      top = Map.get(grid, {i - 1, j}, 100)
      bottom = Map.get(grid, {i + 1, j}, 100)
      left = Map.get(grid, {i, j - 1}, 100)
      right = Map.get(grid, {i, j + 1}, 100)

      if val < top && val < bottom && val < left && val < right do
        acc + 1 + val
      else
        acc
      end
    end)
  end
end
