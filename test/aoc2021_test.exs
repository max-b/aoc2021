defmodule Aoc2021Test do
  use ExUnit.Case
  doctest Aoc2021

  test "day 1 part 1" do
    assert Aoc2021.day1_part1() == 1215
  end

  test "day 1 part 2" do
    assert Aoc2021.day1_part2() == 1150
  end

  test "day 2 part 1" do
    assert Aoc2021.day2_part1() == 1_813_801
  end

  test "day 2 part 2" do
    assert Aoc2021.day2_part2() == 1_960_569_556
  end
end
