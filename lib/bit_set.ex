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
    bit_size = 64

    len =
      ((length + 63) / bit_size)
      |> Kernel.trunc()

    bit_array = Tuple.duplicate(<<0::unsigned-big-integer-size(bit_size)>>, len)

    {:ok, %{data: bit_array, size: bit_size, length: length}}
  end

  @impl true
  def handle_cast({:set, pos, value}, state = %{data: data, size: size, length: length}) do
    array_index = Kernel.div(pos, size)

    if pos >= length do
      {:noreply, state}
    else
      set = elem(data, array_index)
      <<start::size(pos), val::size(1), rest::bits>> = set

      bit_value = if value, do: 1, else: 0
      bit_array =
        if val != bit_value do
          <<start::size(pos), bit_value::size(1), rest::bits>>
        else
          set
        end

      new_data = put_elem(data, array_index, bit_array)
      IO.inspect(new_data)
      {:noreply, %{state | data: new_data}}
    end
  end

  @impl true
  def handle_call({:get, pos}, _from, state = %{data: data, size: size, length: length}) do
    array_index = Kernel.div(pos, size)

    res =
      if pos >= length do
        false
      else
        set = elem(data, array_index)

        <<_::size(pos), val::size(1), _::bits>> = set

        if val == 1 do
          true
        else
          false
        end
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
