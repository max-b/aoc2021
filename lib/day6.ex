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

  @part1_days 80
  @part2_days 256
  @starting_age 8
  @rebirth_age 6

  def age_list(list, day, days) do
    IO.inspect({day, length(list), list})
    # If we're at the end of the list and the last day then don't recurse
    cond do
      day == days ->
        list

      day != days ->
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

        age_list(new_list, day + 1, days)
    end
  end

  def part1 do
    inputs = get_input()
    final_list = age_list(inputs, 0, @part1_days)
    length(final_list)
  end

  def age_day(ages) do
    [birthing | tail] = ages
    rebirth_age_count = Enum.at(tail, @rebirth_age)
    List.replace_at(tail, @rebirth_age, birthing + rebirth_age_count) ++ [birthing]
  end

  def part2 do
    days = @part2_days

    inputs = get_input()

    # map inputs as number of fish in each state
    blank_state = Enum.map(0..8, fn _ -> 0 end)

    initial_state =
      Enum.reduce(inputs, blank_state, fn elem, acc ->
        n = Enum.at(acc, elem)
        List.replace_at(acc, elem, n + 1)
      end)

    ages =
      Enum.reduce(0..(days - 1), initial_state, fn _day, acc ->
        age_day(acc)
      end)

    Enum.reduce(ages, 0, fn elem, acc -> elem + acc end)
  end
end
