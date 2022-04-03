require IEx

defmodule BitSet do
  use Bitwise
  use GenServer

  @moduledoc """
  Documentation for `BitSet`.
  """

  # Callbacks

  @impl true
  def init(length) do
    bit_size = 8

    len =
      ((length + 7) / bit_size)
      |> Kernel.trunc()

    bit_array = Tuple.duplicate(<<0::unsigned-big-integer-size(bit_size)>>, len)

    {:ok, %{data: bit_array, size: bit_size, length: length}}
  end

  @impl true
  def handle_cast({:set, pos, value}, state = %{data: data, size: size, length: length}) do
    array_index = Kernel.div(pos, size)
    array_pos = Kernel.rem(pos, size)

    if pos >= length do
      {:noreply, state}
    else
      <<bit_array>> = elem(data, array_index)

      IO.puts("===Pos: #{array_pos}")

      bit_array =
        if value do
          bit_array ||| 1 <<< array_pos
        else
          bit_array &&& bnot(1 <<< array_pos)
        end

      IO.inspect(Integer.to_string(bit_array, 2))

      new_data = put_elem(data, array_index, <<bit_array>>)
      IO.inspect(new_data)
      {:noreply, %{state | data: new_data}}
    end
  end

  @impl true
  def handle_call({:get, pos}, _from, state = %{data: data, size: size, length: length}) do
    array_index = Kernel.div(pos, size)
    array_pos = Kernel.rem(pos, size)

    res =
      if pos >= length do
        false
      else
        <<bit_array>> = elem(data, array_index)

        Bitwise.band(bit_array, 1 <<< array_pos) != 0
      end

    {:reply, res, state}
  end

  # Client API

  def start_link(opts) do
    GenServer.start(__MODULE__, 8, opts)
  end

  def get(pid, pos) do
    GenServer.call(pid, {:get, pos})
  end

  def set(pid, pos, value) do
    GenServer.cast(pid, {:set, pos, value})
  end
end
