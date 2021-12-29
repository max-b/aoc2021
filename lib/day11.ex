defmodule Day11 do
  def get_grid do
    File.stream!("data/day11")
    |> Stream.map(fn x -> String.replace(x, "\n", "") end)
    |> Stream.map(fn x ->
      String.graphemes(x)
      |> Enum.map(fn x -> elem(Integer.parse(x), 0) end)
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, i}, acc ->
      Enum.reduce(Enum.with_index(row), acc, fn {cell, j}, acc ->
        Map.merge(acc, %{{i, j} => {cell, true}})
      end)
    end)
  end

  @part1_max_days 100

  def print_grid(grid) do
    {max_x, max_y} = find_maxes(grid)

    Enum.each(0..max_x, fn x ->
      Enum.each(0..max_y, fn y ->
        {cell, _can_fire} = grid[{x, y}]
        IO.write(cell)
      end)

      IO.write("\n")
    end)

    IO.write("\n")
  end

  def find_maxes(grid) do
    {{max_x, _}, _} =
      Enum.max_by(grid, fn {{x, _y}, _val} ->
        x
      end)

    {{_, max_y}, _} =
      Enum.max_by(grid, fn {{_x, y}, _val} ->
        y
      end)

    {max_x, max_y}
  end

  def next_point({x, y}, grid) do
    {max_x, _} = find_maxes(grid)

    if x + 1 > max_x do
      {0, y + 1}
    else
      {x + 1, y}
    end
  end

  def nearby_points({x, y}, grid) do
    {max_x, max_y} = find_maxes(grid)

    Enum.filter(
      [
        {x - 1, y},
        {x + 1, y},
        {x, y - 1},
        {x, y + 1},
        {x + 1, y + 1},
        {x - 1, y - 1},
        {x - 1, y + 1},
        {x + 1, y - 1}
      ],
      fn {x, y} ->
        x >= 0 && y >= 0 && x <= max_x && y <= max_y
      end
    )
  end

  def simulate_single_cell(flash_count, point, results) do
    {new_value, can_flash} = results[point]

    # if !can_flash do
    #   IO.inspect("CANT FLASH")
    # end

    cond do
      new_value > 9 && can_flash ->
        new_results = %{results | point => {0, false}}

        Enum.reduce(
          nearby_points(point, results),
          {flash_count + 1, new_results},
          fn {x, y}, {flash_count, results} ->
            {val, can_flash} = results[{x, y}]

            incremented_val =
              if can_flash do
                val + 1
              else
                val
              end

            simulate_single_cell(flash_count, {x, y}, %{
              results
              | {x, y} => {incremented_val, can_flash}
            })
          end
        )

      new_value <= 9 || !can_flash ->
        new_results = %{results | point => {new_value, can_flash}}
        {flash_count, new_results}
    end
  end

  def simulate_day(flash_count, point, results) do
    {_max_x, max_y} = find_maxes(results)

    {flash_count, new_results} = simulate_single_cell(flash_count, point, results)
    next_point = next_point(point, results)
    {_next_x, next_y} = next_point

    if next_y > max_y do
      {flash_count, new_results}
    else
      simulate_day(flash_count, next_point, new_results)
    end
  end

  def simulate(flash_count, results, day) do
    if day >= @part1_max_days do
      {flash_count, results}
    else
      incremented_results =
        Enum.reduce(results, %{}, fn {point, {value, _can_flash}}, acc ->
          Map.merge(acc, %{point => {value + 1, true}})
        end)

      {new_flash_count, new_results} = simulate_day(flash_count, {0, 0}, incremented_results)
      # IO.inspect(%{:new_flash_count => new_flash_count})
      # print_grid(new_results)
      simulate(new_flash_count, new_results, day + 1)
    end
  end

  def part1 do
    grid = get_grid()
    {flashes, _} = simulate(0, grid, 0)
    flashes
  end
end
