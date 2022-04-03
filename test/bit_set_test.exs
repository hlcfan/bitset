defmodule BitSetTest do
  use ExUnit.Case, async: true
  doctest BitSet

  setup do
    child_spec = %{
      id: BitWise,
      start: {BitSet, :start_link, [%{length: 69}]}
    }

    bitset = start_supervised!(child_spec)
    %{bitset: bitset}
  end

  test "sets bit value", %{bitset: bitset} do
    assert BitSet.set(bitset, 1, true)
    assert BitSet.get(bitset, 1) == true
    assert BitSet.get(bitset, 2) == false
  end

  test "sets bit value if multiple words required", %{bitset: bitset} do
    assert BitSet.get(bitset, 66) == false
    assert BitSet.set(bitset, 66, true)
    assert BitSet.get(bitset, 66) == true
  end

  test "sets returns ok if out of bound", %{bitset: bitset} do
    assert BitSet.set(bitset, 96, true) == :ok
  end

  test "gets bit value", %{bitset: bitset} do
    assert BitSet.get(bitset, 1) == false
  end

  test "get returns false if out of bound", %{bitset: bitset} do
    assert BitSet.get(bitset, 20) == false
  end
end
