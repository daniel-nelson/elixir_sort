defmodule SingleProcessorSortTest do
  use ExUnit.Case
  # doctest SingleProcessorSort

  describe "sort" do
    test "returns empty for empty" do
      assert SingleProcessorSort.sort([], &(&1 <= &2)) == []
    end

    test "returns single element for single element" do
      assert SingleProcessorSort.sort([7], &(&1 <= &2)) == [7]
    end

    test "sorts two items" do
      assert SingleProcessorSort.sort([7, 3], &(&1 <= &2)) == [3, 7]
    end

    test "sorts 3 items" do
      assert SingleProcessorSort.sort([7, 3, 11], &(&1 <= &2)) == [3, 7, 11]
    end

    test "sorts 3 items with duplicates" do
      assert SingleProcessorSort.sort([7, 3, 3], &(&1 <= &2)) == [3, 3, 7]
    end

    test "sorts many items" do
      sorted_list = Enum.to_list(1..100)
      randomized_list = Enum.shuffle(sorted_list)
      assert SingleProcessorSort.sort(randomized_list, &(&1 <= &2)) == sorted_list
    end

    test "sorts many items with duplicates" do
      half_list = Enum.to_list(1..100)
      sorted_list = Enum.sort(half_list ++ half_list)
      randomized_list = Enum.shuffle(sorted_list)
      assert SingleProcessorSort.sort(randomized_list, &(&1 <= &2)) == sorted_list
    end
  end

  describe "build_map with an empty list" do
    test "returns an empty map" do
      assert SingleProcessorSort.build_map([], &(&1 <= &2)) == %{}
    end
  end

  describe "build_map with one element" do
    test "returns a map of 0 to that item" do
      assert SingleProcessorSort.build_map([7], &(&1 <= &2)) == %{0 => 7}
    end
  end

  describe "build_map with two elements" do
    test "returns a map of 0 to the smallest item and 1 to the largest item" do
      assert SingleProcessorSort.build_map([7, 3], &(&1 <= &2)) == %{0 => 3, 1 => 7}
    end
  end

  describe "build_map with three elements" do
    test "returns a map of 0 to the smallest item, 1 to the middle item, and 2 to the largest item" do
      assert SingleProcessorSort.build_map([7, 3, 11], &(&1 <= &2)) == %{0 => 3, 1 => 7, 2 => 11}
    end
  end

  describe "build_map with two equal elements" do
    test "returns a map of 0 to the smallest item, 1 to the middle item, and 2 to the largest item" do
      assert SingleProcessorSort.build_map([3, 3], &(&1 <= &2)) == %{0 => 3, 1 => 3}
    end
  end
end
