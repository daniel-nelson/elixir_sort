defmodule ParallelSort do
  def sort(list, sort_function) do
    process_count = kickoff_map_building(list, list, sort_function)
    map = construct_map(%{}, process_count)
    _sort([], length(list) - 1, list, sort_function, map)
  end

  def construct_map(map, 0), do: map

  def construct_map(map, process_count) do
    receive do
      {element, index} ->
        index = index |> ensure_uniq_in_map(element, map)

        Map.put(map, index, element)
        |> construct_map(process_count - 1)
    end
  end

  defp _sort(accumulator, -1, _, _, _), do: accumulator

  defp _sort(accumulator, target_index, list, sort_function, map) do
    [Map.get(map, target_index) | accumulator]
    |> _sort(target_index - 1, list, sort_function, map)
  end

  defp kickoff_map_building(_, _, _, process_count \\ 0)

  defp kickoff_map_building([], _, _, process_count), do: process_count

  defp kickoff_map_building([head | tail], list, sort_function, process_count) do
    spawn(ParallelSort, :parallel_position, {self(), head, list, sort_function})
    kickoff_map_building(tail, list, sort_function, process_count + 1)
  end

  defp ensure_uniq_in_map(index, element, map) do
    if Map.get(map, index) do
      ensure_uniq_in_map(index + 1, element, map)
    else
      index
    end
  end

  def parallel_position({pid, element, list, sort_function}) do
    index = position(element, 0, list, sort_function) # O(N)
    send(pid, {element, index})
  end

  defp position(_, index, [], _), do: index

  defp position(element, index, [head | tail], sort_function) do
    if sort_function.(element, head) do
      position(element, index, tail, sort_function)
    else
      position(element, index + 1, tail, sort_function)
    end
  end
end
