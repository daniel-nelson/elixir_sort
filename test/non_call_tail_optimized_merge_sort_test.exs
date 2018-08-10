defmodule NonCallTailOptimizedMergeSortTest do
  use ExUnit.Case
  doctest NonCallTailOptimizedMergeSort

  describe "sort" do
    test "returns empty for empty" do
      assert NonCallTailOptimizedMergeSort.sort([], &(&1 <= &2)) == []
    end

    test "returns single element for single element" do
      assert NonCallTailOptimizedMergeSort.sort([7], &(&1 <= &2)) == [7]
    end

    test "sorts two items" do
      assert NonCallTailOptimizedMergeSort.sort([7, 3], &(&1 <= &2)) == [3, 7]
    end

    test "sorts 3 items" do
      assert NonCallTailOptimizedMergeSort.sort([7, 3, 11], &(&1 <= &2)) == [3, 7, 11]
    end

    test "sorts 3 items with duplicates" do
      assert NonCallTailOptimizedMergeSort.sort([7, 3, 3], &(&1 <= &2)) == [3, 3, 7]
    end

    test "sorts ten items" do
      sorted_list = Enum.to_list(1..10)
      randomized_list = Enum.shuffle(sorted_list)
      assert NonCallTailOptimizedMergeSort.sort(randomized_list, &(&1 <= &2)) == sorted_list
    end

    test "sorts many items" do
      sorted_list = Enum.to_list(1..100)
      randomized_list = Enum.shuffle(sorted_list)
      assert NonCallTailOptimizedMergeSort.sort(randomized_list, &(&1 <= &2)) == sorted_list
    end

    test "sorts many items with duplicates" do
      half_list = Enum.to_list(1..100)
      sorted_list = Enum.sort(half_list ++ half_list)
      randomized_list = Enum.shuffle(sorted_list)
      assert NonCallTailOptimizedMergeSort.sort(randomized_list, &(&1 <= &2)) == sorted_list
    end
  end

  describe "merge" do
    test "returns empty for empty" do
      assert NonCallTailOptimizedMergeSort.merge([], [], &(&1 <= &2)) == []
    end

    test "returns single element for a single-element list and an empty list" do
      assert NonCallTailOptimizedMergeSort.merge([7], [], &(&1 <= &2)) == [7]
    end

    test "returns single element for an empty list and a single-element list" do
      assert NonCallTailOptimizedMergeSort.merge([], [7], &(&1 <= &2)) == [7]
    end

    test "returns a sorted, two element list for two single-element lists" do
      assert NonCallTailOptimizedMergeSort.merge([7], [3], &(&1 <= &2)) == [3, 7]
    end

    test "returns a sorted 3-element list from a sorted 2-element list and a single-element list" do
      assert NonCallTailOptimizedMergeSort.merge([3, 7], [5], &(&1 <= &2)) == [3, 5, 7]
    end

    test "returns a sorted 4-element list from two sorted 2-element lists" do
      one = [4, 5]
      two = [2, 3]
      assert NonCallTailOptimizedMergeSort.merge(one, two, &(&1 <= &2)) == [2, 3, 4, 5]
    end

    test "returns a sorted 5-element list from two sorted 3-element lists" do
      assert NonCallTailOptimizedMergeSort.merge([3, 4, 7], [2, 5], &(&1 <= &2)) == [2, 3, 4, 5, 7]
    end

    test "returns a sorted many-element list from two sorted many-element lists" do
      one = Enum.to_list(1..100) |> Enum.take_random(77) |> Enum.sort(&(&1 <= &2))
      two = Enum.to_list(1..100) |> Enum.take_random(76) |> Enum.sort(&(&1 <= &2))
      assert NonCallTailOptimizedMergeSort.merge(one, two, &(&1 <= &2)) == (one ++ two) |> Enum.sort(&(&1 <= &2))
    end
  end
end
