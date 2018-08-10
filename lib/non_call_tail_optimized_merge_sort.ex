defmodule NonCallTailOptimizedMergeSort do
  def sort([], _) do
    []
  end

  def sort([head | []], _) do
    [head]
  end

  def sort(list, sort_function) do
    {one, two} = split(list, [], [])

    merge(
      sort(one, sort_function),
      sort(two, sort_function),
      sort_function
    )
  end

  def split([], one, two) do
    {one, two}
  end

  def split([head_one | []], one, two) do
    {[head_one | one], two}
  end

  def split([head_one | [head_two | tail]], one, two) do
    split(tail, [head_one | one], [head_two | two])
  end

  def merge([], [], _) do
    []
  end

  def merge(one, [], _) do
    one
  end

  def merge([], two, _) do
    two
  end

  def merge([head_one | one], [head_two | two], sort_function) do
    if sort_function.(head_one, head_two) do
      [head_one | merge(one, [head_two | two], sort_function)]
    else
      [head_two | merge([head_one | one], two, sort_function)]
    end
  end
end
