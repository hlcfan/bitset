require IEx

defmodule BitSet do
  use GenServer
  @bit_size 64

  @moduledoc """
  Documentation for `BitSet`.
  """

  # Callbacks

  @impl true
  def init(length) do
    len =
      ((length + @bit_size - 1) / @bit_size)
      |> Kernel.trunc()

    bit_array = Tuple.duplicate(<<0::unsigned-big-integer-size(@bit_size)>>, len)

    {:ok, %{data: bit_array, size: @bit_size, length: length}}
  end

  @impl true
  def handle_cast({:set, pos, value}, state = %{data: data, size: size, length: length}) do
    if pos >= length do
      {:noreply, state}
    else
      array_index = Kernel.div(pos, size)
      set = elem(data, array_index)
      bit_array = set_bit(pos|>Kernel.rem(@bit_size), value, set)

      new_data = put_elem(data, array_index, bit_array)
      {:noreply, %{state | data: new_data}}
    end
  end

  defp set_bit(pos, value, set) when is_boolean(value) do
    bit_value = if value, do: 1, else: 0
    set_bit(pos, bit_value, set)
  end

  defp set_bit(pos, value, set) when is_integer(value) do
    <<start::size(pos), val::size(1), rest::bits>> = set

    if val != value do
      <<start::size(pos), value::size(1), rest::bits>>
    else
      set
    end
  end

  @impl true
  def handle_call({:get, pos}, _from, state = %{data: data, size: size, length: length}) do
    res =
      if pos >= length do
        false
      else
        array_index = Kernel.div(pos, size)
        set = elem(data, array_index)
        pos = pos |> Kernel.rem(@bit_size)

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

  @spec start_link(map()) :: {atom(), pid()}
  def start_link(opts \\ %{length: 8}) do
    GenServer.start(__MODULE__, opts[:length])
  end

  @spec get(pid(), non_neg_integer()) :: boolean()
  def get(pid, pos) do
    GenServer.call(pid, {:get, pos})
  end

  @spec set(pid(), non_neg_integer(), boolean()) :: atom()
  def set(pid, pos, value) do
    GenServer.cast(pid, {:set, pos, value})
  end
end
