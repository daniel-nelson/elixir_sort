defmodule QuickSort do
  def sort([], _) do
    []
  end

  def sort([head | tail], sort_function) do
    (for x <- tail, sort_function.(x, head) do x end |> sort(sort_function))
    ++
    [head]
    ++
    (for x <- tail, !sort_function.(x, head) do x end |> sort(sort_function))
  end
end
