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

  def validate_command(_valid, []) do
    {true, 0}
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
end
