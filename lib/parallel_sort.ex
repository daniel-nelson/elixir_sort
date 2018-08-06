defmodule ParallelSort do
  def sort(list, sort_function) do
    n = length(list)
    pids = distribute_work(list, n, self(), true, [], sort_function, true)
    build_sorted_list(pids, [])
  end

  # 1. Distribute work
  def distribute_work([], _, _, _, pids, _, _) do
    pids
  end

  def distribute_work([value | remaining_values], n, previous_pid, my_turn_to_work, pids, sort_function, is_first) do
    is_last = case remaining_values do
      [] -> true
      _ -> false
    end
    pid = spawn(ParallelSort, :work, [value, n, n, previous_pid, my_turn_to_work, sort_function, is_first, is_last])
    distribute_work(remaining_values, n, pid, !my_turn_to_work, [pid | pids], sort_function, false)
  end

  # 2. Work
  def work(value, 0, 0, _, _, _, _, _) do
    receive do
      {:get_value, sender_pid} ->
        send(sender_pid, {:collect_value, value})
    end
  end

  def work(
    value, n, called_n, previous_pid, my_turn_to_work, sort_function, is_first, is_last
  ) when my_turn_to_work and is_first do
    n = max(n - 1, 0)
    work(value, n, called_n, previous_pid, !my_turn_to_work, sort_function, is_first, is_last)
  end

  def work(
    value, n, called_n, previous_pid, my_turn_to_work, sort_function, is_first, is_last
  ) when my_turn_to_work do
    n = max(n - 1, 0)
    send(previous_pid, {:compare, value, self()})

    receive do
      {:update_value, new_value} ->
        work(new_value, n, called_n, previous_pid, !my_turn_to_work, sort_function, is_first, is_last)

      {:no_value_change} ->
        work(value, n, called_n, previous_pid, !my_turn_to_work, sort_function, is_first, is_last)
    end
  end

  def work(
    value, n, called_n, previous_pid, my_turn_to_work, sort_function, is_first, is_last
  ) when is_last do
    called_n = max(called_n - 1, 0)
    work(value, n, called_n, previous_pid, !my_turn_to_work, sort_function, is_first, is_last)
  end

  def work(
    value, n, called_n, previous_pid, my_turn_to_work, sort_function, is_first, is_last
  ) do
    called_n = max(called_n - 1, 0)

    receive do
      {:compare, sender_value, sender_pid} ->
        if sort_function.(value, sender_value) do
          send(sender_pid, {:no_value_change})
          work(value, n, called_n, previous_pid, !my_turn_to_work, sort_function, is_first, is_last)

        else
          send(sender_pid, {:update_value, value})
          work(sender_value, n, called_n, previous_pid, !my_turn_to_work, sort_function, is_first, is_last)
        end
    end
  end

  # 3. Build the sorted list when the work of sorting is complete
  def build_sorted_list([], sorted_list) do
    sorted_list
  end

  def build_sorted_list([pid | pids], sorted_list) do
    # IO.inspect([pid | pids])
    send(pid, {:get_value, self()})

    receive do
      {:collect_value, value} ->
        build_sorted_list(pids, [value | sorted_list])
    end
  end
end
