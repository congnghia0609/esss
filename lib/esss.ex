# @author nghiatc
# @since Feb 17, 2025

defmodule ESSS do
  @moduledoc """
  Documentation for `ESSS`.
  """

  # The largest PRIME 256-bit
  # https://primes.utm.edu/lists/2small/200bit.html
  # prime = 2^n - k = 2^256 - 189
  @prime 115792089237316195423570985008687907853269984665640564039457584007913129639747

  def get_prime, do: @prime

  @doc """
  Returns a random number from the range 1 <= n <= @prime-1 inclusive
  """
  def random_number() do
    :rand.uniform(@prime-1)
  end

  @doc """
  Computes the multiplicative inverse of the number on the field @prime.
  """
  def modinv(a, m) do
    {g, x, _y} = Integer.extended_gcd(a, m)
    if g != 1 do
      raise("modular inverse does not exist")
    else
      Integer.mod(x, m)
    end
  end

  @doc """
  Returns the Int number base10 in Hex representation.
  note: this is not a string representation; the Hex output is exactly 256 bits long.
  """
  def to_hex(number) do
    hex_string = Integer.to_string(number, 16) |> String.pad_leading(64, "0")
    hex_string
  end

  @doc """
  Returns the number Hex in base 10 Int representation.
  note: this is not coming from a string representation; the Hex input is
  exactly 256 bits long, and the output is an arbitrary size base 10 integer.
  """
  def from_hex(hex) do
    String.to_integer(hex, 16)
  end

  defmodule UniqueList do
    def generate(0, set), do: MapSet.to_list(set)
    def generate(n, set) do
      random_num = ESSS.random_number()
      generate(n-1, MapSet.put(set, random_num))
    end
  end

  @doc """
  Update value of matrix[x][y] at index row x and index column y
  """
  def update_matrix_2d(matrix, x, y, value) do
    updated_matrix = List.replace_at(matrix, x, List.replace_at(Enum.at(matrix, x), y, value))
    updated_matrix
  end

  @doc """
  Get value of matrix[x][y] at index row x and index column y
  """
  def get_matrix_2d(matrix, x, y) do
    value = Enum.at(Enum.at(matrix, x), y)
    value
  end

  @doc """
  Generate matrix[x][y] init all zero with x row and y column
  """
  def gen_zero_matrix_2d(x, y) do
    zero_matrix = List.duplicate(List.duplicate(0, y), x)
    zero_matrix
  end
end
