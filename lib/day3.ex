defmodule Day3 do
  use Bitwise

  def numbers do
    filestream = File.stream!("data/day3")

    Stream.map(filestream, fn x -> String.replace(x, "\n", "") end)
    |> Stream.map(fn x ->
      String.graphemes(x)
      |> Enum.map(fn x -> elem(Integer.parse(x), 0) end)
    end)
  end

  def sum_digits(digits_list) do
    blank_slate = 0..12 |> Enum.map(fn _ -> 0 end)

    Enum.reduce(digits_list, blank_slate, fn digits, acc ->
      Enum.zip(acc, digits)
      |> Enum.map(fn {start_digit, compare_digit} ->
        case compare_digit do
          0 -> start_digit - 1
          1 -> start_digit + 1
        end
      end)
    end)
  end

  def convert_bit_list(bit_list) do
    Enum.with_index(Enum.reverse(bit_list))
    |> Enum.reduce(0, fn {count, i}, acc ->
      cond do
        count > 0 ->
          acc + Integer.pow(2, i)

        count <= 0 ->
          acc
      end
    end)
  end

  def part1 do
    digits_sum = sum_digits(numbers())

    gamma = convert_bit_list(digits_sum)

    epsilon = ~~~gamma &&& 0xFFF

    epsilon * gamma
  end

  def oxygen_rating(values, _digit_index) when length(values) == 1 do
    List.first(values)
  end

  def oxygen_rating(values, digit_index) do
    digits_sum = sum_digits(values)
    {index_sum, _} = List.pop_at(digits_sum, digit_index)

    cond do
      index_sum >= 0 ->
        oxygen_rating(
          Enum.filter(values, fn x ->
            elem(List.pop_at(x, digit_index), 0) == 1
          end),
          digit_index + 1
        )

      index_sum < 0 ->
        oxygen_rating(
          Enum.filter(values, fn x ->
            elem(List.pop_at(x, digit_index), 0) == 0
          end),
          digit_index + 1
        )
    end
  end

  def co2_rating(values, _digit_index) when length(values) == 1 do
    List.first(values)
  end

  def co2_rating(values, digit_index) do
    digits_sum = sum_digits(values)
    {index_sum, _} = List.pop_at(digits_sum, digit_index)

    cond do
      index_sum >= 0 ->
        co2_rating(
          Enum.filter(values, fn x ->
            elem(List.pop_at(x, digit_index), 0) == 0
          end),
          digit_index + 1
        )

      index_sum < 0 ->
        co2_rating(
          Enum.filter(values, fn x ->
            elem(List.pop_at(x, digit_index), 0) == 1
          end),
          digit_index + 1
        )
    end
  end

  def part2 do
    numbers_list = numbers() |> Enum.to_list()
    o = convert_bit_list(oxygen_rating(numbers_list, 0))
    co2 = convert_bit_list(co2_rating(numbers_list, 0))

    o * co2
  end
end
