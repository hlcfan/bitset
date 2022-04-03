# BitSet

A simple implementation of BitSet using GenServer.

It stores data in 64 bits.

## API

``` elixir
iex(11)> {:ok, pid} = GenServer.start_link(BitSet, 42)
{:ok, #PID<0.168.0>}
iex(12)> BitSet.get(pid, 24)
false
iex(13)> BitSet.set(pid, 24, true)
:ok
iex(14)> BitSet.get(pid, 24)
true
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bit_set` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bit_set, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bit_set](https://hexdocs.pm/bit_set).

