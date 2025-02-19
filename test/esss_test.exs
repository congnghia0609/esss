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

  test "Gen list random" do
    n = 10
    list = ESSS.UniqueList.generate(n, MapSet.new())
    # IO.inspect(list)
    assert length(list) == n

    c = 3
    for i <- 1..c do
      if i == c do
        sub_list = Enum.slice(list, 0, c)
        # IO.inspect(sub_list)
        assert length(sub_list) == c
        list = Enum.slice(list, c, n - c)
        # IO.inspect(list)
        assert length(list) == n - c
      end
    end
    # IO.puts("---------")
    # IO.inspect(list)
    assert length(list) == n
    # for x <- 1..2, y <- 1..3, z <- 1..4 do
    #   IO.puts("x=#{x}, y=#{y}, z=#{z}")
    # end
  end

  test "Test matrix 2d" do
    value = 9
    x = 2
    y = 3
    # Create a 2-row, 3-column zero matrix
    zero_matrix = ESSS.gen_zero_matrix_2d(x, y)
    # IO.inspect(zero_matrix) # [[0, 0, 0], [0, 0, 0]]
    zero_matrix = ESSS.update_matrix_2d(zero_matrix, 0, 1, value)
    # IO.inspect(zero_matrix) # [[0, 9, 0], [0, 0, 0]]
    v = ESSS.get_matrix_2d(zero_matrix, 0, 1)
    # IO.puts(v) # 9
    assert v == value
  end

  test "Test matrix 3d" do
    # Create a 2-layer, 3-row, 4-column zero matrix
    l = 2
    m = 3
    n = 4
    zero_3d_matrix = ESSS.gen_zero_matrix_3d(l, m, n)
    # IO.inspect(zero_3d_matrix)
    # [
    #   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]],
    #   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
    # ]
    value = 9
    zero_3d_matrix = ESSS.update_matrix_3d(zero_3d_matrix, 0, 1, 2, 9)
    # IO.inspect(zero_3d_matrix)
    # [
    #   [[0, 0, 0, 0], [0, 0, 9, 0], [0, 0, 0, 0]],
    #   [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
    # ]
    v = ESSS.get_matrix_3d(zero_3d_matrix, 0, 1, 2)
    # IO.puts(v)
    assert v == value
  end

  test "Test EncodeSecret DecodeSecret" do
    s = "nghiatcxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    arr = ESSS.split_secret_to_int(s)
    # IO.inspect(arr)
    # [49937119214509114343548691117920141602615245118674498473442528546336026425464,
    # 54490394935207621375798110592323721342715286901477912489156510121370884536440,
    # 54490394935207621375798110592323721342715286901477912489156510121370884536440,
    # 54490394935207621375798110592321034758823134506407685127331664012878869954560]
    rs = ESSS.merge_int_to_string(arr)
    # IO.inspect(rs)
    assert rs == s
  end

  test "Test is_valid_share_hex" do
    share = "5DFED9C42E64134575ADA1B01FDF8708F64BE245D86AA39322E6B9BDDFA296FE5A9A16B3A18950130CC47DC3BEFB5E997886A1ECD249790C9B820CCEAC31BA4B73E6C23E63554BADB5A259291B2A4A48D780A957A3255F75903CF3F680C16494090C920DA9AD92A3DE8A05E405EA87E0F4BF493F79B0DF1C14EE8230CB5E54337DF2B6E1DDCD983BCE57338FDBC71C22993B2DBAF72F100A36686A7FE63CBDE3148EDC18248F5AB6B06FB4E669209258BF5F1B228EB08B6BEDF75CDDFCC88F378EBAFD88F3BBAB17392EBB8ABFA2A8EBD83103BDE6CD84D1F71F1C894BE7A5347494BCAE96DCC089E5E03B5F764DD6CA109A7C58938D7CE54CB722FFA38262A1"
    ESSS.is_valid_share_hex(share)
  end

  test "Test decode_share_hex" do
    shares = [
      "4CEF4360238832695E3C3B1CDB313A234723D57FB9E09CBEBA2658F38B7F39B48EBDE8C6826773DB4A5B75E846C0E74214C4DBD8236A9E61ACE4365FF097302D507D2945D74AF1105DCABDC3ACDA65A55AAC1740CA0FCC5B8C02B286F45CC3956A4ED0EFA40CA380867E5728890A8725F3F19FAD4F40FD20D55ED8CAFEF988E0547AAC4BF28D8C202F526A499547EF17C81C7379CF4D5A1147F89F0CF4D7AB7738D5132962EF1C50E7F53DA43A88741E4EA18D2654349A8A4D6DE4891F8252BF54C70243AC376F4B2139FA58328D87D4B490C0BEA03B219E1666EC3DF8F97B76776C1FB2C5A1D4A051BE9E306FDF7E62566CEC0E9A0FA50443379A28584CCAA3",
      "5DFED9C42E64134575ADA1B01FDF8708F64BE245D86AA39322E6B9BDDFA296FE5A9A16B3A18950130CC47DC3BEFB5E997886A1ECD249790C9B820CCEAC31BA4B73E6C23E63554BADB5A259291B2A4A48D780A957A3255F75903CF3F680C16494090C920DA9AD92A3DE8A05E405EA87E0F4BF493F79B0DF1C14EE8230CB5E54337DF2B6E1DDCD983BCE57338FDBC71C22993B2DBAF72F100A36686A7FE63CBDE3148EDC18248F5AB6B06FB4E669209258BF5F1B228EB08B6BEDF75CDDFCC88F378EBAFD88F3BBAB17392EBB8ABFA2A8EBD83103BDE6CD84D1F71F1C894BE7A5347494BCAE96DCC089E5E03B5F764DD6CA109A7C58938D7CE54CB722FFA38262A1",
      "9DEABB7E60914C96F181CCDA316AB373302C2AF9CDE23AD3DB760FE5B4BC6DDD774E6CFC7C0125ACCD5E5E6E057EE5F1E153CED365161EE40C62D36A63D2E6C1A4D9A0FFF79B15D79D9024B32BE6B58FAE8AE2B11A368E8C4EF84ACD92750E6C3C21071941EAF67C40885A7D4767DD2B5DF305CDEEDF3493879F4DF92C8B30CBA836D6FCE7E0C96B145B49477819FA4B92123FFDD8E2B583AEB6B877CD3F41DE86FE18B9A215B0B9156318F53234A710332D1D15C8467758519F5D9993E9670DAF4A954293C1FDE8E44807B7CA91F48A2B43EC2D31ABD57E69FE82341D7CD6EBFF5C136C4A36DFD4B26E74F7B6D1AAA8BE738F593F81A0B532C68604CC8275D6",
      "B4B01EA1F0C417AAC85AAEAE072BA4ACE2BBE9E99FEEC4B085D8D9151AF83D13E854D632649E310B29896002EBBF85B0BE8417F3F0CE1760B4EB8F529BF0F033C098CDE1C406437FB285C4D8D3DD8A776225A71D6010699DAE2730A150945E49A2BB958D601B8283A4FD46751933A6D7B61BCE08CD939C752AA6BB3FEF95381AC6D96793FB14C226280020DB6F43C5E483E18E9C0F21EE101B18A4C0924A47051F9931582FA4C0E9117BE18075BDFBD00C06CC8808075E1E9195462B48055FD8C7CCE2E8D02C3BA3A5CEF0999A3FFDBC547D1C1CA5293BD13104D66BC3EFF0B6D23D4B5E479A08ED41C7307338BFA9A949DFD6B19EB86ACC33C76633215D5713",
      "D55F2672EC3BD18E18B56EBCF6F0C6C54218EA0F838FDE835AD2002BA0C221113E7B4BC6C0CAD5CF8F621FC23071BA481DCB404159A251C203D3108E0BE730FFD69BD4CBFBFF73907404DC900532318086CC0064D5D5381411776F610723DFB4677A779FF6E10868A2D941CED7F780276399D083DDD8BABA041603ED300F9CB1D8D4ADF5B46FA5AC4331ED7D3939FC368A5BD31CACCA188338A8FE4D862E1668B7048846FEBC93EDE97217B35C3BCC46A371E4D08DBC3EF1C15DBEBEF5C7B366E5D280741AF3AD9EAC5F28A01D53572BA1F0B74D940B266CCEDECB567C53F1F4B34B03414ADAAB4DCCA38F7A1EDA77EACCA76BC97E75CBD31E7BE8C36F9ED570",
      "EC0A27DB8B1B1E572C63953192BA432ED734D393E191868E75ED369632EAA9BD8ABC41B0B23F721DC5AEB1E94574C84482ABEEFF4E48AC493940F4764462E1B6EFF284D8E9B3571CB2688298643D05E9C960FB9DF455715B14FF79797103C6995EEA2123869DA8F5429F4F3CA85EDE6AFD64E96602C1C64428B641ADB9BA17A6F89A53329F1A42D21D74DE0366E16F20370F03E2C343BAC0739CFBEFA23DA7285027CF528DD028A96150A58EF0FDDE4E55155DA4075C47DAE15ED4A51A310F85FB4A38579DD62C21A677BC14BA13F427585E39A8939A37BFAF998B0A271054E0544E5BBC95C9D6FE60DC506C5795AA881E13F0A4F8777BBC0323A94DD388F622"
    ]
    _points = ESSS.decode_share_hex(shares)
    # IO.inspect(points)
  end

  test "Test full SSS hex" do
    # for i <- 0..4 do
    #   IO.puts(i) # 0 1 2 3 4
    # end
    s = "nghiatcxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

    # creates a set of shares
    case ESSS.create(3, 6, s, false) do
      {:ok, list} ->
        # Case normal
        case ESSS.combine(Enum.slice(list, 0, 3), false) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case normal
        case ESSS.combine(Enum.slice(list, 3, 3), false) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case normal
        case ESSS.combine(Enum.slice(list, 1, 4), false) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case abnormal
        case ESSS.combine(Enum.slice(list, 0, 2), false) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 != s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
      {:error, msg} ->
        IO.puts(msg)
        assert false
    end
    # IO.puts("-------------------------")
    # IO.inspect(list)
    # ["4CEF4360238832695E3C3B1CDB313A234723D57FB9E09CBEBA2658F38B7F39B48EBDE8C6826773DB4A5B75E846C0E74214C4DBD8236A9E61ACE4365FF097302D507D2945D74AF1105DCABDC3ACDA65A55AAC1740CA0FCC5B8C02B286F45CC3956A4ED0EFA40CA380867E5728890A8725F3F19FAD4F40FD20D55ED8CAFEF988E0547AAC4BF28D8C202F526A499547EF17C81C7379CF4D5A1147F89F0CF4D7AB7738D5132962EF1C50E7F53DA43A88741E4EA18D2654349A8A4D6DE4891F8252BF54C70243AC376F4B2139FA58328D87D4B490C0BEA03B219E1666EC3DF8F97B76776C1FB2C5A1D4A051BE9E306FDF7E62566CEC0E9A0FA50443379A28584CCAA3",
    # "5DFED9C42E64134575ADA1B01FDF8708F64BE245D86AA39322E6B9BDDFA296FE5A9A16B3A18950130CC47DC3BEFB5E997886A1ECD249790C9B820CCEAC31BA4B73E6C23E63554BADB5A259291B2A4A48D780A957A3255F75903CF3F680C16494090C920DA9AD92A3DE8A05E405EA87E0F4BF493F79B0DF1C14EE8230CB5E54337DF2B6E1DDCD983BCE57338FDBC71C22993B2DBAF72F100A36686A7FE63CBDE3148EDC18248F5AB6B06FB4E669209258BF5F1B228EB08B6BEDF75CDDFCC88F378EBAFD88F3BBAB17392EBB8ABFA2A8EBD83103BDE6CD84D1F71F1C894BE7A5347494BCAE96DCC089E5E03B5F764DD6CA109A7C58938D7CE54CB722FFA38262A1",
    # "9DEABB7E60914C96F181CCDA316AB373302C2AF9CDE23AD3DB760FE5B4BC6DDD774E6CFC7C0125ACCD5E5E6E057EE5F1E153CED365161EE40C62D36A63D2E6C1A4D9A0FFF79B15D79D9024B32BE6B58FAE8AE2B11A368E8C4EF84ACD92750E6C3C21071941EAF67C40885A7D4767DD2B5DF305CDEEDF3493879F4DF92C8B30CBA836D6FCE7E0C96B145B49477819FA4B92123FFDD8E2B583AEB6B877CD3F41DE86FE18B9A215B0B9156318F53234A710332D1D15C8467758519F5D9993E9670DAF4A954293C1FDE8E44807B7CA91F48A2B43EC2D31ABD57E69FE82341D7CD6EBFF5C136C4A36DFD4B26E74F7B6D1AAA8BE738F593F81A0B532C68604CC8275D6",
    # "B4B01EA1F0C417AAC85AAEAE072BA4ACE2BBE9E99FEEC4B085D8D9151AF83D13E854D632649E310B29896002EBBF85B0BE8417F3F0CE1760B4EB8F529BF0F033C098CDE1C406437FB285C4D8D3DD8A776225A71D6010699DAE2730A150945E49A2BB958D601B8283A4FD46751933A6D7B61BCE08CD939C752AA6BB3FEF95381AC6D96793FB14C226280020DB6F43C5E483E18E9C0F21EE101B18A4C0924A47051F9931582FA4C0E9117BE18075BDFBD00C06CC8808075E1E9195462B48055FD8C7CCE2E8D02C3BA3A5CEF0999A3FFDBC547D1C1CA5293BD13104D66BC3EFF0B6D23D4B5E479A08ED41C7307338BFA9A949DFD6B19EB86ACC33C76633215D5713",
    # "D55F2672EC3BD18E18B56EBCF6F0C6C54218EA0F838FDE835AD2002BA0C221113E7B4BC6C0CAD5CF8F621FC23071BA481DCB404159A251C203D3108E0BE730FFD69BD4CBFBFF73907404DC900532318086CC0064D5D5381411776F610723DFB4677A779FF6E10868A2D941CED7F780276399D083DDD8BABA041603ED300F9CB1D8D4ADF5B46FA5AC4331ED7D3939FC368A5BD31CACCA188338A8FE4D862E1668B7048846FEBC93EDE97217B35C3BCC46A371E4D08DBC3EF1C15DBEBEF5C7B366E5D280741AF3AD9EAC5F28A01D53572BA1F0B74D940B266CCEDECB567C53F1F4B34B03414ADAAB4DCCA38F7A1EDA77EACCA76BC97E75CBD31E7BE8C36F9ED570",
    # "EC0A27DB8B1B1E572C63953192BA432ED734D393E191868E75ED369632EAA9BD8ABC41B0B23F721DC5AEB1E94574C84482ABEEFF4E48AC493940F4764462E1B6EFF284D8E9B3571CB2688298643D05E9C960FB9DF455715B14FF79797103C6995EEA2123869DA8F5429F4F3CA85EDE6AFD64E96602C1C64428B641ADB9BA17A6F89A53329F1A42D21D74DE0366E16F20370F03E2C343BAC0739CFBEFA23DA7285027CF528DD028A96150A58EF0FDDE4E55155DA4075C47DAE15ED4A51A310F85FB4A38579DD62C21A677BC14BA13F427585E39A8939A37BFAF998B0A271054E0544E5BBC95C9D6FE60DC506C5795AA881E13F0A4F8777BBC0323A94DD388F622"]
  end

  test "Test full SSS hex with special cases not Latin symbols" do
    s = "бар"  # Cyrillic

    # creates a set of shares
    case ESSS.create(3, 6, s, false) do
      {:ok, list} ->
        # Case normal
        case ESSS.combine(Enum.slice(list, 0, 3), false) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case normal
        case ESSS.combine(Enum.slice(list, 3, 3), false) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case normal
        case ESSS.combine(Enum.slice(list, 1, 4), false) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case abnormal
        case ESSS.combine(Enum.slice(list, 0, 2), false) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 != s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
      {:error, msg} ->
        IO.puts(msg)
        assert false
    end
  end

  test "Test Encode Decode Base64URLSafe" do
    number = 67356225285819719212258382314594931188352598651646313425411610888829358649431
    # IO.inspect(number)

    # encode
    b64data = ESSS.to_base64(number)
    # IO.inspect(b64data)
    # IO.inspect(String.length(b64data))
    assert b64data == "lOpFwywpCeVAcK0_LOKG-YtW71xyj1bX06CcW7VZMFc="
    assert String.length(b64data) == 44

    # decode
    numb64decode = ESSS.from_base64(b64data)
    # IO.inspect(numb64decode)
    assert numb64decode == numb64decode
  end

  test "Test is_valid_share_base64" do
    share = "coKbKOpKsucIF0hLgL6r2dOJpQ52TXnqU4Y4Znc26aU=Byrn3KrQn8Rq8-F49THePjAxy1fkixnjf7H-Q82tlNY=C-17nZaq6PPDfHCDPIpmVa928rUYAXxkhop-1dhyEqg=kn_fIXrpRCh1WluMW2EQddz9Vlj7m4SlUWnSAupD6yQ=yrT7uX2bF0AEdOUFQx1sd-SAYBj4vY0wLQaXkilp9LQ=65RU1AOhohmmN5dmKChFipsCdCraLIu1I0tlfUCdtdQ=_oHtNTo71hjx5RO_BaDJq2hiZTvpQjN6-O4n6zf8F_M=bd5XjTzbwgZIoXDCeqX_lGbCAIW1kepA-j6xRChI5Co="
    ESSS.is_valid_share_base64(share)
  end

  test "Test full SSS base64" do
    s = "nghiatcxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

    # creates a set of shares
    case ESSS.create(3, 6, s, true) do
      {:ok, list} ->
        # IO.inspect(list)
        # Case normal
        case ESSS.combine(Enum.slice(list, 0, 3), true) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case normal
        case ESSS.combine(Enum.slice(list, 3, 3), true) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case normal
        case ESSS.combine(Enum.slice(list, 1, 4), true) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case abnormal
        case ESSS.combine(Enum.slice(list, 0, 2), true) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 != s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
      {:error, msg} ->
        IO.puts(msg)
        assert false
    end
    # IO.puts("-------------------------")
    # IO.inspect(list)
    # ["LsfdJ7RBavmnuSvknyYRVVF3AzAAp3X_qLz1Hi2u618=0FszC6FCPhfv-CjaBIm2t68tBB7uKnK4wnMmZaOZQPs=N53AGgxtv86K5pjkpsNrVCjqYrkt0RHszIs5ptLJEOo=Q9HLCU_88-O2CPffbQfWw0fdKQTtUL9hEinL2qx7ebI=PYMVj9wk43m0RCq7SbLN0WZYZfPZL4fAKTu7fQy8L8I=9a3JRNMZcfYiH3wQ4YdGzyc7Y1-Xt9PIqMFcugufpvc=QRqi16Ll6GPNTotxJ2YUTpSzzL5ftPJwiyIYHt7DqcQ=Rb3rXZc7wnBUGG1bM1DrDMBZ6q4xrhpvCbSrLekoCAg=",
    # "QfoZF4e7qx8y0bhg7l1cRboz5DkIACUy5NGcHOMeyrU=9SaGXcePbuiCmzZytY0B_y43b2mN9ViI0XYh7OfKZ3U=REQZe6abmS4I40zU0Ji5-HqZdK6ep4IkC24Lpfzk134=x_uiTWbr33JgkSYU_XqtTo5pqMo3K2rihSd2mmVCUxQ=Zp_tMVEKyM-Q_ONrNkahnQMEa4J6ZIJMZscrxCcWEno=xIaJDbUkaZz0_zaZno5SSV7crCqFfgWgxihWv7Q13lQ=a4o3Vyphvfn723gBce7gJCGVnexjiSZEL6U9KLUsGVI=HbFjsGd1UdmcHvODKVgvVXE_ceBCB7IdGZWWao4AfJw=",
    # "bkXHs5iRgXW8znKzA5pJqwuJqdKwTlB-UQxFUyHh-q4=jZwGw-_-wJRKnxIowIZ_LXMH9SHEVaK5bgJnXo07snQ=cds77nHl2FDaYKQaqLkSrF2eb0GAzWxiD8nDkHzQ23M=CJgC7ngY4YSfe7cVpXfgqEBs6uEGdoX4Tg7hIaS3mG0=k1ZIc-900vOYXDodjyKPvqJLDTjmk_e-riGfgK3-P8s=ptJnEAxpGfTnnXyvLrSyr4agG_--7t_kfPClX0DkaIc=lHUgYZwQGJLRb516iXUOwODvDErMBojP3sNo01h9Ffg=Bw-1qd_io2Y4qWvHh48j4y_2tvjlWPeh9Qb0CstQhtw=",
    # "nQ3XTGw8w4ua4DZQlhrbN6Tugr1RRg0CMiRigipKNb0=0VMPZAHFz562Tfv9BuM-o-T7adpP2KOkCJDz_PYaFT8=oUQwvZ_TFkyQJx-5SACHOLyBvQWFPilAs211gh-J-OM=VcJywX4Bq_uwpBS3k7-qAbLBMwegiYn84_4jaZHw0ro=p_td_brlADGWz8ydwKigtpl0dlMkj4l2-DVKNSORsyw=2aY-8CJqeEg4UfLfnloUeVURJBH1Knt-wkZIPl8-U8Q=tl7UZi43gFlG1cSLGc-IUGgYIntKbyfDMxp0YvehcIM=JRm_EpMCKLc1K99fepnK2M8if90duyk8nbHFRnV1qig=",
    # "36G01gT5B9CJWA98tTsqeQNCzu5joECR2nsEZwSbNQA=rzIyBkVrJ5KDPMpWC-4Z3oXzEZNlyyfLbYBWK6uH13E=3-EqD0XSpD_uxsw4gPD4fcvGmUyBm_IUr8abjKi3n2w=d1xbu3kCUdvS3_IyqNI-m_pFsLMetqQPKk-Ih3dU_AA=5b1P80Rw2qDwd1IrBen63L3lY1RFm_SK6-BhnQ0NLjs=xuJ1A_oqR1fzXx5Yda_M6RrcCo5v8ipMg42fYqD0GsQ=52GF6OkqQ4-J7dR3OPnqpSZohP5qxBMWrTF5Vo___E8=rv6u7KckqoJIHGrE4xjC1JIijn633HEo1wJByqxz730=",
    # "7OKrTmyFD6ACPKVMO7QhgBPwd5X43LxERHBEAL6etXQ=FIJVulL-viUacc3jaf9-UXQg-RPZeDHIGXLCcWVO4VQ=7qWXfKU8cFv05oYYGb5wb4H3nS8usHwkRqrvd2QzHOk=qV2-xBGh9zE9fSOsxDnGbTM5N097ehXwnfm0M_bTg7A=_E1_UP1AaW5VDNFa7xkTxRw_9M7vSu8R7cyrs6HrFp8=4-Nd_6uJa_JWB2l8al12qbRjVzgZiNFVNwtzIWIfhRg=_S2MBEGkmJrAQbDEA5ct1Ls6_8rAEbRGYtugctfiaNM=mB0hiCExdZxcqTGgmyt5OVYmhJcS3k4oXEc9WNVOF68="]
  end

  test "Test full SSS base64 with special cases not Latin symbols" do
    s = "бар"  # Cyrillic

    # creates a set of shares
    case ESSS.create(3, 6, s, true) do
      {:ok, list} ->
        # Case normal
        case ESSS.combine(Enum.slice(list, 0, 3), true) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case normal
        case ESSS.combine(Enum.slice(list, 3, 3), true) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case normal
        case ESSS.combine(Enum.slice(list, 1, 4), true) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 == s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
        # Case abnormal
        case ESSS.combine(Enum.slice(list, 0, 2), true) do
          {:ok, s1 } ->
            # IO.inspect(s1)
            assert s1 != s
          {:error, msg} ->
            IO.puts(msg)
            assert false
        end
      {:error, msg} ->
        IO.puts(msg)
        assert false
    end
  end
end
