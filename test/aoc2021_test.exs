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

  test "day 5 part 1" do
    assert Day5.part1() == 6461
  end

  test "day 5 part 2" do
    assert Day5.part2() == 18065
  end

  test "day 6 part 1" do
    assert Day6.part1() == 380_243
  end

  test "day 6 part 2" do
    assert Day6.part2() == 1_708_791_884_591
  end
end
