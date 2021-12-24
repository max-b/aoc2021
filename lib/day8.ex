defmodule Day8 do
  def get_input do
    filestream =
      File.stream!("data/day8")
      |> Stream.map(fn row ->
        trimmed_row = String.replace(row, "\n", "")
        [inputs, outputs] = String.split(trimmed_row, "|")

        %{
          :inputs => String.trim(inputs) |> String.split(" "),
          :outputs => String.trim(outputs) |> String.split(" ")
        }
      end)

    filestream
  end

  def part1 do
    unique_segment_nums = [2, 4, 3, 7]
    inputs = get_input()

    Enum.reduce(inputs, 0, fn %{:inputs => _, :outputs => outputs}, acc ->
      IO.inspect({outputs, acc})

      Enum.reduce(outputs, acc, fn output, acc ->
        IO.inspect({output, acc})

        if Enum.member?(unique_segment_nums, String.length(output)) do
          acc + 1
        else
          acc
        end
      end)
    end)
  end
end
