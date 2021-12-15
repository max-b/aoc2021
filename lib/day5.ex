defmodule Day5 do
  def make_vectors do
    filestream =
      File.stream!("data/day5")
      |> Stream.map(fn row ->
        trimmed_row = String.replace(row, "\n", "")
        [head, tail] = String.split(trimmed_row, " -> ")

        make_coordinates = fn pair ->
          [x, y] = String.split(pair, ",")
          {x, _} = Integer.parse(x)
          {y, _} = Integer.parse(y)
          %{:x => x, :y => y}
        end

        %{:head => make_coordinates.(head), :tail => make_coordinates.(tail)}
      end)

    filestream
  end

  def find_max_values(vectors) do
    Enum.reduce(vectors, %{:x => 0, :y => 0}, fn vector, acc ->
      max_x = max(acc.x, vector.head.x)
      max_x = max(max_x, vector.tail.x)
      max_y = max(acc.y, vector.head.y)
      max_y = max(max_y, vector.tail.y)

      %{:x => max_x, :y => max_y}
    end)
  end

  def part1 do
    vectors = make_vectors()

    %{:x => max_x, :y => max_y} = find_max_values(vectors)

    starting_board =
      0..max_y
      |> Enum.map(fn _ -> 0 end)
      |> Enum.map(fn _ -> 0..max_x |> Enum.map(fn _ -> 0 end) end)

    end_board =
      Enum.reduce(vectors, starting_board, fn vector, acc ->
        new_board =
          cond do
            vector.head.x == vector.tail.x ->
              vector.head.y..vector.tail.y
              |> Enum.reduce(acc, fn point_y, acc ->
                row = Enum.fetch!(acc, point_y)
                cell_val = Enum.fetch!(row, vector.head.x)
                List.replace_at(acc, point_y, List.replace_at(row, vector.head.x, cell_val + 1))
              end)

            vector.head.y == vector.tail.y ->
              vector.head.x..vector.tail.x
              |> Enum.reduce(acc, fn point_x, acc ->
                row = Enum.fetch!(acc, vector.head.y)
                cell_val = Enum.fetch!(row, point_x)
                List.replace_at(acc, vector.head.y, List.replace_at(row, point_x, cell_val + 1))
              end)

            true ->
              acc
          end

        new_board
      end)

    Enum.reduce(end_board, 0, fn row, acc ->
      row_count =
        Enum.reduce(row, 0, fn cell, acc ->
          cond do
            cell > 1 -> acc + 1
            true -> acc
          end
        end)

      acc + row_count
    end)
  end

  def part2 do
    vectors = make_vectors()

    %{:x => max_x, :y => max_y} = find_max_values(vectors)

    starting_board =
      0..max_y
      |> Enum.map(fn _ -> 0 end)
      |> Enum.map(fn _ -> 0..max_x |> Enum.map(fn _ -> 0 end) end)

    end_board =
      Enum.reduce(vectors, starting_board, fn vector, acc ->
        new_board =
          cond do
            vector.head.x == vector.tail.x ->
              vector.head.y..vector.tail.y
              |> Enum.reduce(acc, fn point_y, acc ->
                row = Enum.fetch!(acc, point_y)
                cell_val = Enum.fetch!(row, vector.head.x)
                List.replace_at(acc, point_y, List.replace_at(row, vector.head.x, cell_val + 1))
              end)

            vector.head.y == vector.tail.y ->
              vector.head.x..vector.tail.x
              |> Enum.reduce(acc, fn point_x, acc ->
                row = Enum.fetch!(acc, vector.head.y)
                cell_val = Enum.fetch!(row, point_x)
                List.replace_at(acc, vector.head.y, List.replace_at(row, point_x, cell_val + 1))
              end)

            abs(vector.tail.y - vector.head.y) == abs(vector.tail.x - vector.head.x) ->
              Enum.zip(vector.head.x..vector.tail.x, vector.head.y..vector.tail.y)
              |> Enum.reduce(acc, fn {point_x, point_y}, acc ->
                row = Enum.fetch!(acc, point_y)
                cell_val = Enum.fetch!(row, point_x)
                List.replace_at(acc, point_y, List.replace_at(row, point_x, cell_val + 1))
              end)

            true ->
              acc
          end

        new_board
      end)

    Enum.reduce(end_board, 0, fn row, acc ->
      row_count =
        Enum.reduce(row, 0, fn cell, acc ->
          cond do
            cell > 1 -> acc + 1
            true -> acc
          end
        end)

      acc + row_count
    end)
  end
end
