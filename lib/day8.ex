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
      Enum.reduce(outputs, acc, fn output, acc ->
        if Enum.member?(unique_segment_nums, String.length(output)) do
          acc + 1
        else
          acc
        end
      end)
    end)
  end

  def get_translation(input_strings) do
    input = Enum.map(input_strings, &String.graphemes(&1))

    one_letters_index = Enum.find_index(input, fn letters -> length(letters) == 2 end)

    one_letters = Enum.fetch!(input, one_letters_index)

    four_letters_index = Enum.find_index(input, fn letters -> length(letters) == 4 end)

    four_letters = Enum.fetch!(input, four_letters_index)

    seven_letters_index = Enum.find_index(input, fn letters -> length(letters) == 3 end)

    seven_letters = Enum.fetch!(input, seven_letters_index)

    eight_letters_index = Enum.find_index(input, fn letters -> length(letters) == 7 end)

    eight_letters = Enum.fetch!(input, eight_letters_index)

    letters_with_six = Enum.filter(input, &(length(&1) == 6))
    letters_with_five = Enum.filter(input, &(length(&1) == 5))

    # 9 has all characters from the 4, the other two (zero and six) don't
    nine_letters_index =
      Enum.find_index(letters_with_six, fn letters ->
        Enum.all?(four_letters, &Enum.member?(letters, &1))
      end)

    nine_letters = Enum.fetch!(letters_with_six, nine_letters_index)
    remaining_letters_with_six = List.delete_at(letters_with_six, nine_letters_index)

    # zero has all characters from the 1, six doesn't
    zero_letters_index =
      Enum.find_index(remaining_letters_with_six, fn letters ->
        Enum.all?(one_letters, &Enum.member?(letters, &1))
      end)

    zero_letters = Enum.fetch!(remaining_letters_with_six, zero_letters_index)

    [six_letters] = List.delete_at(remaining_letters_with_six, zero_letters_index)

    # letters_with_five now has 2, 3, and 5
    # the 3 and 5 are both included within the 9
    three_and_five =
      Enum.filter(letters_with_five, fn letters ->
        Enum.all?(letters, &Enum.member?(nine_letters, &1))
      end)

    two_letters_index = Enum.find_index(letters_with_five, &(!Enum.member?(three_and_five, &1)))

    two_letters = Enum.fetch!(letters_with_five, two_letters_index)

    remaining_letters_with_five = List.delete_at(letters_with_five, two_letters_index)

    # now just need to distinguish 3 and 5 and 3 contains all letters from one
    three_letters_index =
      Enum.find_index(remaining_letters_with_five, fn test_letters ->
        Enum.all?(one_letters, &Enum.member?(test_letters, &1))
      end)

    three_letters = Enum.fetch!(remaining_letters_with_five, three_letters_index)
    [five_letters] = List.delete_at(remaining_letters_with_five, three_letters_index)

    %{
      Enum.sort(zero_letters) => "0",
      Enum.sort(one_letters) => "1",
      Enum.sort(two_letters) => "2",
      Enum.sort(three_letters) => "3",
      Enum.sort(four_letters) => "4",
      Enum.sort(five_letters) => "5",
      Enum.sort(six_letters) => "6",
      Enum.sort(seven_letters) => "7",
      Enum.sort(eight_letters) => "8",
      Enum.sort(nine_letters) => "9"
    }
  end

  def get_output_val(inputs, outputs) do
    translation_key = get_translation(inputs)

    outputs =
      Enum.map(outputs, fn output_string ->
        output = Enum.sort(String.graphemes(output_string))

        value = translation_key[output]
        value
      end)

    {v, _} = Integer.parse(Enum.join(outputs))
    v
  end

  def part2 do
    inputs = get_input() |> Enum.to_list()

    Enum.reduce(inputs, 0, fn elem, acc ->
      %{:inputs => inputs, :outputs => outputs} = elem
      acc + get_output_val(inputs, outputs)
    end)
  end
end
