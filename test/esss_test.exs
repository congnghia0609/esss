defmodule ESSSTest do
  use ExUnit.Case
  # doctest ESSS

  test "Gen random number" do
    n = ESSS.random_number()
    # IO.puts(n)
    assert 0 < n
    assert n < ESSS.get_prime()
  end

  test "Get modinv" do
    x = ESSS.modinv(2, 7)
    # IO.puts(x)
    assert x == 4
  end

  test "Get hex string of integer" do
    hex = ESSS.to_hex(255)
    # IO.puts(hex)
    assert hex == "00000000000000000000000000000000000000000000000000000000000000FF"
    assert String.length(hex) == 64
  end

  test "Get integer from hex string" do
    i = ESSS.from_hex("00000000000000000000000000000000000000000000000000000000000000FF")
    # IO.puts(i)
    assert i == 255
  end
end
