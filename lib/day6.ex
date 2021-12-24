defmodule Day6 do
  def get_input do
    input = File.read!("data/day6")

    lanternfish_list =
      String.split(input, ",")
      |> Enum.map(fn i ->
        {x, _} = Integer.parse(i)
        x
      end)

    lanternfish_list
  end

  @days 80
  @starting_age 8
  @rebirth_age 6

  def age_list(list, day) do
    # If we're at the end of the list and the last day then don't recurse
    cond do
      day == @days ->
        list

      day != @days ->
        new_list =
          Enum.flat_map(list, fn age ->
            new_fish_age = age - 1

            cond do
              new_fish_age >= 0 ->
                [new_fish_age]

              new_fish_age < 0 ->
                [@rebirth_age, @starting_age]
            end
          end)

        age_list(new_list, day + 1)
    end
  end

  def part1 do
    inputs = get_input()
    final_list = age_list(inputs, 0)
    length(final_list)
  end
end
