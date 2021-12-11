defmodule Aoc2021Test do
  use ExUnit.Case

  test "day 1 part 1" do
    assert Day1.part1() == 1215
  end

  test "day 1 part 2" do
    assert Day1.part2() == 1150
  end

  test "day 2 part 1" do
    assert Day2.part1() == 1_813_801
  end

  test "day 2 part 2" do
    assert Day2.part2() == 1_960_569_556
  end
end
