defmodule Day10 do
  def get_commands do
    File.stream!("data/day10")
    |> Stream.map(fn x -> String.replace(x, "\n", "") end)
    |> Stream.map(fn x ->
      String.graphemes(x)
    end)
  end

  def opens?(char) do
    Enum.member?(["(", "[", "<", "{"], char)
  end

  def closes?(test, valid) do
    (valid == "(" && test == ")") ||
      (valid == "[" && test == "]") ||
      (valid == "<" && test == ">") ||
      (valid == "{" && test == "}")
  end

  def validate_command(valid, [head | tail]) do
    case valid do
      [valid_head | valid_tail] ->
        cond do
          opens?(head) ->
            validate_command([head | valid], tail)

          closes?(head, valid_head) ->
            validate_command(valid_tail, tail)

          !closes?(head, valid_head) ->
            {false, head}
        end

      [] ->
        validate_command([head], tail)
    end
  end

  def validate_command(valid, []) do
    {true, valid}
  end

  def part1 do
    values = %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}
    results = Enum.map(get_commands(), &validate_command([], &1))

    Enum.reduce(results, 0, fn {result, value}, acc ->
      if result do
        acc
      else
        acc + values[value]
      end
    end)
  end

  @close_map %{"(" => ")", "{" => "}", "[" => "]", "<" => ">"}

  def finish_command(finish_list, [head | tail]) do
    finish_command([@close_map[head] | finish_list], tail)
  end

  def finish_command(finish_list, []) do
    # We need to reverse this because we've been using head | tail and not pushing to the end
    Enum.reverse(finish_list)
  end

  def part2 do
    values = %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

    results =
      Enum.map(get_commands(), &validate_command([], &1))
      |> Enum.filter(fn {result, _} -> result end)
      |> Enum.map(fn {_result, valid} -> valid end)

    finish_lists = Enum.map(results, &finish_command([], &1))

    scores =
      Enum.map(finish_lists, fn finish_list ->
        Enum.reduce(finish_list, 0, fn letter, acc ->
          acc * 5 + values[letter]
        end)
      end)

    sorted = Enum.sort(scores)
    middle_num = Enum.fetch!(sorted, Integer.floor_div(length(sorted), 2))

    middle_num
  end
end
