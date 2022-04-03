defmodule BitSetTest do
  use ExUnit.Case, async: true
  doctest BitSet

  setup do
    bitset = start_supervised!(BitSet)
    %{bitset: bitset}
  end

  test "sets bit value",%{bitset: bitset} do
    assert BitSet.set(bitset, 1, true)
    assert BitSet.get(bitset, 1) == true
    assert BitSet.get(bitset, 2) == false
  end

  test "gets bit value",%{bitset: bitset} do
    assert BitSet.get(bitset, 1) == false
  end

  test "raises error if out of bound",%{bitset: bitset} do
    assert BitSet.get(bitset, 20) == false
  end

end
