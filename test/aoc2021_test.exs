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

  test "day 3 part 1" do
    assert Day3.part1() == 4_103_154
  end

  test "day 3 part 2" do
    assert Day3.part2() == 4_245_351
  end

  test "day 4 part 1" do
    assert Day4.part1() == 14093
  end

  test "day 4 part 2" do
    assert Day4.part2() == 17388
  end
end
