defmodule ParallelSortTest do
  use ExUnit.Case
  doctest ParallelSort

  describe "sort" do
    test "returns empty for empty" do
      assert ParallelSort.sort([], &(&1 <= &2)) == []
    end

    test "returns single element for single element" do
      assert ParallelSort.sort([7], &(&1 <= &2)) == [7]
    end

    test "sorts two items" do
      assert ParallelSort.sort([7, 3], &(&1 <= &2)) == [3, 7]
    end

    test "sorts 3 items" do
      assert ParallelSort.sort([7, 3, 11], &(&1 <= &2)) == [3, 7, 11]
    end

    test "sorts 3 items with duplicates" do
      assert ParallelSort.sort([7, 3, 3], &(&1 <= &2)) == [3, 3, 7]
    end

    test "sorts many items" do
      sorted_list = Enum.to_list(1..100)
      randomized_list = Enum.shuffle(sorted_list)
      assert ParallelSort.sort(randomized_list, &(&1 <= &2)) == sorted_list
    end

    test "sorts many items with duplicates" do
      half_list = Enum.to_list(1..100)
      sorted_list = Enum.sort(half_list ++ half_list)
      randomized_list = Enum.shuffle(sorted_list)
      assert ParallelSort.sort(randomized_list, &(&1 <= &2)) == sorted_list
    end
  end
end
