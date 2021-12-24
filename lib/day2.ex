defmodule Day2 do
  def commands do
    filestream = File.stream!("data/day2-input1")

    Stream.map(filestream, fn x -> String.replace(x, "\n", "") end)
    |> Stream.map(fn x -> String.split(x, " ") end)
  end

  def part1 do
    commands = commands()

    pos =
      Enum.reduce(
        commands,
        [{:forward, 0}, {:depth, 0}],
        fn command, acc ->
          [direction, magnitude_string] = command
          [{:forward, forward}, {:depth, depth}] = acc
          {magnitude, _} = Integer.parse(magnitude_string)

          newpos =
            case direction do
              "forward" -> [{:forward, forward + magnitude}, {:depth, depth}]
              "down" -> [{:forward, forward}, {:depth, depth + magnitude}]
              "up" -> [{:forward, forward}, {:depth, depth - magnitude}]
            end

          newpos
        end
      )

    pos[:forward] * pos[:depth]
  end

  def part2 do
    commands = commands()

    pos =
      Enum.reduce(
        commands,
        [{:forward, 0}, {:depth, 0}, {:aim, 0}],
        fn command, acc ->
          [direction, magnitude_string] = command
          [{:forward, forward}, {:depth, depth}, {:aim, aim}] = acc
          {magnitude, _} = Integer.parse(magnitude_string)

          newpos =
            case direction do
              "down" ->
                [{:forward, forward}, {:depth, depth}, {:aim, aim + magnitude}]

              "up" ->
                [{:forward, forward}, {:depth, depth}, {:aim, aim - magnitude}]

              "forward" ->
                [{:forward, forward + magnitude}, {:depth, depth + aim * magnitude}, {:aim, aim}]
            end

          newpos
        end
      )

    pos[:forward] * pos[:depth]
  end
end
