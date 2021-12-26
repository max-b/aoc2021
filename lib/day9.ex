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

  def touching?({x1, y1}, {x2, y2}) do
    (x1 == x2 && abs(y2 - y1) == 1) ||
      (y1 == y2 && abs(x2 - x1) == 1)
  end

  def find_top_3_basins(basins, maxes) do
    if length(maxes) >= 3 do
      maxes
    else
      max_basin = Enum.max_by(basins, fn basin -> length(basin) end)

      new_maxes = [max_basin | maxes]

      new_basins = Enum.filter(basins, fn basin -> !Enum.member?(new_maxes, basin) end)

      find_top_3_basins(
        new_basins,
        new_maxes
      )
    end
  end

  def part2 do
    grid = get_grid()

    basins =
      Enum.reduce(grid, [], fn {{i, j}, val}, basins ->
        if val == 9 do
          basins
        else
          touching_basins =
            Enum.filter(basins, fn basin ->
              Enum.any?(basin, fn basin_pt -> touching?({i, j}, basin_pt) end)
            end)

          if length(touching_basins) == 0 do
            [[{i, j}]] ++ basins
          else
            new_basin = [{i, j} | List.flatten(touching_basins)]

            basins_without_touching =
              Enum.filter(basins, fn basin -> !Enum.member?(touching_basins, basin) end)

            [new_basin | basins_without_touching]
          end
        end
      end)

    top_3_basins = find_top_3_basins(basins, [])

    Enum.reduce(top_3_basins, 1, fn basin, acc ->
      acc * length(basin)
    end)
  end
end
