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
      before = MapSet.size(set)
      random_num = ESSS.random_number()
      set = MapSet.put(set, random_num)
      if MapSet.size(set) > before do
        generate(n-1, set)
      else
        generate(n, set)
      end
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

  @doc """
  Converts a string secret into a 256-bit Int array, array based upon size of the input string.
  All values are right-padded to length 256, even if the most significant bit is zero.
  """
  def split_secret_to_int(secret) do
    hex_secret = :binary.encode_hex(secret)
    count = div((String.length(hex_secret) + 63), 64) # ceil_div = div(a + b - 1, b)
    result = ESSS.EncodeSecret.encode_secret(count, count, hex_secret, [])
    result
  end

  @doc """
  Converts an array of Ints to the original string secret, removing any least significant nulls.
  """
  def merge_int_to_string(secrets) do
    hex_data = Enum.map(secrets, fn item -> ESSS.to_hex(item) end) |> Enum.join("")
    hex_data = String.replace_trailing(hex_data, "00", "")
    secret = :binary.decode_hex(hex_data)
    secret
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
  Create a Zero Matrix(mxn) m-row and n-column
  """
  def gen_zero_matrix_2d(m, n) do
    zero_matrix = List.duplicate(List.duplicate(0, n), m)
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

  def validator_create(minimum, shares, secret) do
    if minimum <= 0 || shares <= 0 do
      raise ArgumentError, "minimum or shares is invalid"
    end
    if minimum > shares do
      raise ArgumentError, "cannot require more shares then existing"
    end
    if String.length(secret) == 0 do
      raise ArgumentError, "secret is empty"
    end
  end

  defmodule SetPolynomialMinimum do
    def set_polynomial_minimum(step, count, part, numbers, polynomial) when count - step < count do
      i = count - step
      x = Enum.at(numbers, (i - 1) + part * count)
      polynomial = ESSS.update_matrix_2d(polynomial, part, i, x)
      set_polynomial_minimum(step-1, count, part, numbers, polynomial)
    end
    def set_polynomial_minimum(0, _count, _part, _numbers, polynomial) do
      polynomial
    end
  end

  defmodule SetPolynomialPart do
    def set_polynomial_part(step, count, minimum, numbers, secrets, polynomial) when count - step < count do
      part = count - step
      s = Enum.at(secrets, part)
      polynomial = ESSS.update_matrix_2d(polynomial, part, 0, s)
      polynomial = ESSS.SetPolynomialMinimum.set_polynomial_minimum(minimum-1, minimum, part, numbers, polynomial)
      set_polynomial_part(step-1, count, minimum, numbers, secrets, polynomial)
    end
    def set_polynomial_part(0, _count, _minimum, _numbers, _secrets, polynomial) do
      polynomial
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
      if s > 0 do
        result = Integer.mod(result * value + ESSS.get_matrix_2d(polynomial, part, s), ESSS.get_prime)
        evaluate_polynomial(s-1, polynomial, part, value, result)
      else
        result
      end
    end
  end

  defmodule CreatePointSecret do
    def create_point_secret(step, count, share, minimum, numbers, polynomial, result) when count - step < count do
      j = count - step
      x = Enum.at(numbers, j + share * count)
      y = ESSS.get_matrix_2d(polynomial, j, minimum-1)
      y = ESSS.Polynomial.evaluate_polynomial(minimum-2, polynomial, j, x, y)
      s = ESSS.to_hex(x) <> ESSS.to_hex(y)
      result = result <> s
      create_point_secret(step-1, count, share, minimum, numbers, polynomial, result)
    end
    def create_point_secret(0, _count, _share, _minimum, _numbers, _polynomial, result) do
      result
    end
  end

  @doc """
  Returns a new array of secret shares (encoding x,y pairs as Base64 or Hex strings)
  created by Shamir's Secret Sharing Algorithm requiring a minimum number of
  share to recreate, of length shares, from the input secret raw as a string.
  """
  def create(minimum, shares, secret) do
    try do
      validator_create(minimum, shares, secret)

      # Convert the secrets to its respective 256-bit Int representation.
      secrets = split_secret_to_int(secret)
      # IO.inspect(secrets)
      # [49937119214509114343548691117920141602615245118674498473442528546336026425464,
      # 54490394935207621375798110592323721342715286901477912489156510121370884536440,
      # 54490394935207621375798110592323721342715286901477912489156510121370884536440,
      # 54490394935207621375798110592321034758823134506407685127331664012878869954560]

      # List unique numbers in the polynomial and array shares
      parts = length(secrets)
      n = parts * (minimum - 1) + parts * shares
      numbers = ESSS.UniqueList.generate(n, MapSet.new())

      # Create the polynomial of degree (minimum - 1); that is, the highest
      # order term is (minimum-1), though as there is a constant term with
      # order 0, there are (minimum) number of coefficients.
      #
      # However, the polynomial object is a 2d array, because we are constructing
      # a different polynomial for each part of the secrets.
      #
      # polynomial[parts][minimum]
      polynomial = gen_zero_matrix_2d(parts, minimum)
      polynomial = SetPolynomialPart.set_polynomial_part(parts, parts, minimum, numbers, secrets, polynomial)
      # IO.inspect(polynomial)
      # [
      #   [49937119214509114343548691117920141602615245118674498473442528546336026425464,
      #    3331610641690559845569293452519156689672205589426266039906276531268282534352,
      #    3449414794780110805560807496417991613898224245219726297399471851840616607059],
      #   [54490394935207621375798110592323721342715286901477912489156510121370884536440,
      #    8375165756357712393989323944985270402269773385317059146875412268233859265345,
      #    20974281055222873671621056844777992892465701255324192649072266731850168978512],
      #   [54490394935207621375798110592323721342715286901477912489156510121370884536440,
      #    26551649736996319523308626035337288866988142478182735537656910010563570288933,
      #    30168152852942397170062579339393015055940095427731866340022962626704826834008],
      #   [54490394935207621375798110592321034758823134506407685127331664012878869954560,
      #    37017445994805835743927682915662589031883038797457847082397075036203361423551,
      #    41353851645870733950560656760353246098763225697893792174345635206631048655938]
      # ]

      # Create the points object; this holds the (x, y) points of each share.
      # Again, because secrets is an array, each share could have multiple parts
      # over which we are computing Shamir's Algorithm. The last dimension is
      # always two, as it is storing an x, y pair of points.
      #
      # Note: this array is technically unnecessary due to creating result
      # in the inner loop. Can disappear later if desired.
      #
      # For every share...
      numbers = Enum.slice(numbers, parts * (minimum - 1), parts * shares)
      # IO.puts("length numbers: #{length(numbers)} == #{parts * shares}")
      result = for share <- 0..(shares-1) do
        ESSS.CreatePointSecret.create_point_secret(parts, parts, share, minimum, numbers, polynomial, "")
      end
      result
    rescue
      e in ArgumentError -> {:error, e.message}
    end
  end
end
