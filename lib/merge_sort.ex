defmodule MergeSort do
  def sort([], _) do
    []
  end

  def sort([head | []], _) do
    [head]
  end

  def sort(list, sort_function) do
    {one, two} = split(list, [], [])

    merge(
      sort(one, sort_function) |> Enum.reverse,
      sort(two, sort_function) |> Enum.reverse,
      sort_function,
      []
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

  def merge([], [], _, accumulator) do
    accumulator
  end

  def merge(one, [], _, accumulator) do
    Enum.reverse(one) ++ accumulator
  end

  def merge([], two, _, accumulator) do
    Enum.reverse(two) ++ accumulator
  end

  def merge([head_one | one], [head_two | two], sort_function, accumulator) do
    if sort_function.(head_one, head_two) do
      merge([head_one | one], two, sort_function, [head_two | accumulator])
    else
      merge(one, [head_two | two], sort_function, [head_one | accumulator])
    end
  end
end
