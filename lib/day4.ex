defmodule Day4 do
  def transpose_board(board) do
    Enum.with_index(board)
    |> Enum.map(fn {row, i} ->
      Enum.with_index(row)
      |> Enum.map(fn {_cell, j} ->
        Enum.at(Enum.at(board, j), i)
      end)
    end)
  end

  def has_row_winner(board) do
    Enum.any?(board, fn row ->
      Enum.all?(row, fn cell ->
        cell[:called]
      end)
    end)
  end

  def board_is_winner(board) do
    row_winner = has_row_winner(board)

    transposed = transpose_board(board)
    column_winner = has_row_winner(transposed)

    row_winner || column_winner
  end

  def numbers_and_boards do
    filestream = File.stream!("data/day4")

    numbers =
      Stream.take(filestream, 1)
      |> Enum.to_list()
      |> List.first()
      |> String.replace("\n", "")
      |> String.split(",")
      |> Enum.map(fn x -> elem(Integer.parse(x), 0) end)

    boards =
      Stream.drop(filestream, 2)
      # THERE MUST BE A NEWLINE AT END OF BOARDS FOR THIS CHUNKING TO WORK
      |> Stream.chunk_every(6)
      |> Enum.map(fn board ->
        Enum.map(board, fn row ->
          String.trim(String.replace(row, "\n", ""))
          # normalize to just one space so we can split later
          |> String.replace("  ", " ")
        end)
        |> Enum.filter(fn row -> row != "" end)
        |> Enum.map(fn row ->
          String.split(row, " ")
          |> Enum.map(fn cell ->
            cell_value = elem(Integer.parse(cell), 0)
            %{:number => cell_value, :called => false}
          end)
        end)
      end)

    %{:numbers => numbers, :boards => boards}
  end

  def update_boards(boards, number) do
    Enum.map(boards, fn board ->
      Enum.map(board, fn row ->
        Enum.map(row, fn cell ->
          cond do
            cell[:number] == number ->
              %{cell | :called => true}

            cell[:number] != number ->
              cell
          end
        end)
      end)
    end)
  end

  def sum_board(board) do
    Enum.reduce(board, 0, fn row, acc ->
      Enum.reduce(row, acc, fn cell, acc ->
        cond do
          !cell[:called] -> acc + cell[:number]
          cell[:called] -> acc
        end
      end)
    end)
  end

  def run_part1(boards, [number | rest]) do
    new_boards = update_boards(boards, number)

    winning_boards = Enum.filter(new_boards, fn board -> board_is_winner(board) end)

    cond do
      length(winning_boards) > 0 -> {winning_boards, number}
      length(winning_boards) == 0 -> run_part1(new_boards, rest)
    end
  end

  def part1 do
    %{:numbers => numbers, :boards => boards} = numbers_and_boards()

    {winning_boards, number} = run_part1(boards, numbers)
    board_sum = sum_board(Enum.at(winning_boards, 0))
    board_sum * number
  end

  def boards_match(board1, board2) do
    Enum.zip(board1, board2)
    |> Enum.all?(fn {row1, row2} ->
      Enum.zip(row1, row2)
      |> Enum.all?(fn {cell1, cell2} ->
        cell1[:number] == cell2[:number]
      end)
    end)
  end

  def run_part2(boards, [number | rest]) do
    new_boards = update_boards(boards, number)

    winning_boards = Enum.filter(new_boards, fn board -> board_is_winner(board) end)

    boards_without_winner =
      Enum.filter(new_boards, fn board ->
        !Enum.any?(winning_boards, fn winning_board ->
          boards_match(winning_board, board)
        end)
      end)

    cond do
      length(boards) == 1 && length(winning_boards) == 1 -> {winning_boards, number}
      true -> run_part2(boards_without_winner, rest)
    end
  end

  def part2 do
    %{:numbers => numbers, :boards => boards} = numbers_and_boards()

    {last_board, number} = run_part2(boards, numbers)
    board_sum = sum_board(Enum.at(last_board, 0))
    board_sum * number
  end
end
