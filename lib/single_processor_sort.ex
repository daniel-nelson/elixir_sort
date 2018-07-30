defmodule SingleProcessorSort do
  def sort(list, sort_function) do
    map = build_map(list, sort_function)
    _sort([], length(list) - 1, list, sort_function, map)
  end

  defp _sort(accumulator, -1, _, _, _) do
    accumulator
  end

  defp _sort(accumulator, target_index, list, sort_function, map) do
    [Map.get(map, target_index) | accumulator]
    |> _sort(target_index - 1, list, sort_function, map)
  end

  def build_map(list, sort_function) do
    %{}
    |> _build_map(list, list, sort_function)
  end

  # O(N^2) unless we can rewrite this so it happens in separate processes and we have N processors
  defp _build_map(map, [], _, _) do
    map
  end

  defp _build_map(map, [head | tail], list, sort_function) do
    index = position(head, list, 0, sort_function) # O(N) unless we can rewrite this so it happens in separate processes and we have N processors
    |> ensure_uniq_in_map(head, map)

    Map.put(map, index, head)
    |> _build_map(tail, list, sort_function)
  end

  defp ensure_uniq_in_map(index, element, map) do
    if Map.get(map, index) do
      ensure_uniq_in_map(index + 1, element, map)
    else
      index
    end
  end

  defp position(_, [], index, _) do
    index
  end

  defp position(element, [head | tail], index, sort_function) do
    if sort_function.(element, head) do
      position(element, tail, index, sort_function)
    else
      position(element, tail, index + 1, sort_function)
    end
  end
end
