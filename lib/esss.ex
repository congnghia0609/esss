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

  defmodule Polynomial do
    @moduledoc """
    Evaluates a polynomial with coefficients specified in reverse order:
      evaluatePolynomial([a, b, c, d], x):
        return a + bx + cx^2 + dx^3
    Horner's method: ((dx + c)x + b)x + a
    """
    def evaluate_polynomial(0, polynomial, part, value, result) do
      result = Integer.mod(result * value + ESSS.get_matrix_2d(polynomial, part, 0), ESSS.get_prime)
      result
    end
    def evaluate_polynomial(s, polynomial, part, value, result) do
      result = Integer.mod(result * value + ESSS.get_matrix_2d(polynomial, part, s), ESSS.get_prime)
      evaluate_polynomial(s-1, polynomial, part, value, result)
    end
  end

  defmodule EncodeSecret do
    def encode_secret(step, count, hex_secret, result) when count - step < count do
      i = count - step
      sub = if (i + 1) * 64 < String.length(hex_secret) do
        String.to_integer(String.slice(hex_secret, i * 64, 64), 16)
      else
        String.to_integer(String.pad_trailing(String.slice(hex_secret, i * 64, String.length(hex_secret) - (i * 64)), 64, "0"), 16)
      end
      result = result ++ [sub]
      encode_secret(step-1, count, hex_secret, result)
    end
    def encode_secret(0, _count, _hex_secret, result) do
      result
    end
  end

  def split_secret_to_int(s) do
    hex_secret = :binary.encode_hex(s)
    count = div((String.length(hex_secret) + 63), 64) # ceil_div = div(a + b - 1, b)
    result = ESSS.EncodeSecret.encode_secret(count, count, hex_secret, [])
    result
  end

  @doc """
  Update an Element in a 2D Matrix(mxn) at index x-row, y-column
  """
  def update_matrix_2d(matrix, x, y, value) do
    updated_matrix = List.replace_at(matrix, x, List.replace_at(Enum.at(matrix, x), y, value))
    updated_matrix
  end

  @doc """
  Get an Element in a 2D Matrix(mxn) at index x-row, y-column
  """
  def get_matrix_2d(matrix, x, y) do
    value = Enum.at(Enum.at(matrix, x), y)
    value
  end

  @doc """
  Create a Zero Matrix(mxn) m row and n column
  """
  def gen_zero_matrix_2d(x, y) do
    zero_matrix = List.duplicate(List.duplicate(0, y), x)
    zero_matrix
  end

  @doc """
  Create a l-layer, m-row, n-column zero matrix(lxmxn)
  """
  def gen_zero_matrix_3d(l, m, n) do
    zero_3d_matrix = List.duplicate(List.duplicate(List.duplicate(0, n), m), l)
    zero_3d_matrix
  end

  @doc """
  Update an Element in a 3D Matrix(lxmxn) at index x-layer, y-row, z-column
  """
  def update_matrix_3d(matrix_3d, x, y, z, value) do
    updated_matrix = List.replace_at(matrix_3d, x,
      List.replace_at(Enum.at(matrix_3d, x), y,
        List.replace_at(Enum.at(Enum.at(matrix_3d, x), y), z, value)
      )
    )
    updated_matrix
  end

  @doc """
  Get an Element in a 3D Matrix(lxmxn) at index x-layer, y-row, z-column
  """
  def get_matrix_3d(matrix_3d, x, y, z) do
    value = Enum.at(Enum.at(Enum.at(matrix_3d, x), y), z)
    value
  end

end
