# SSS
sss is an implement of Shamir's Secret Sharing Algorithm 256-bits in Elixir  

## Installation

Adding `sss` to your list of dependencies in `mix.exs`:  

```elixir
def deps do
  [
    {:sss, "~> 0.1.0"}
  ]
end
```

## 1. An implement of Shamir's Secret Sharing Algorithm 256-bits in Elixir

### Usage
**Use encode/decode Base64URL**  
```elixir
s = "nghiatcxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Creates a set of shares
case SSS.create(3, 6, s, true) do
  {:ok, list} ->
    # Case normal
    case SSS.combine(Enum.slice(list, 0, 3), true) do
      {:ok, s1 } ->
        # IO.inspect(s1)
        assert s1 == s
      {:error, msg} ->
        IO.puts(msg)
        assert false
    end
  {:error, msg} ->
    IO.puts(msg)
    assert false
end

# or

# Creates a set of shares
list = SSS.create!(3, 6, s, true)
# Combines shares into secret
s1 = SSS.combine!(Enum.slice(list, 0, 3), true)
assert s1 == s
```

**Use encode/decode Hex**  
```elixir
s = "nghiatcxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Creates a set of shares
case SSS.create(3, 6, s, false) do
  {:ok, list} ->
    # Case normal
    case SSS.combine(Enum.slice(list, 0, 3), false) do
      {:ok, s1 } ->
        assert s1 == s
      {:error, msg} ->
        IO.puts(msg)
        assert false
    end
  {:error, msg} ->
    IO.puts(msg)
    assert false
end

# or

# Creates a set of shares
list = SSS.create!(3, 6, s, false)
# Combines shares into secret
s1 = SSS.combine!(Enum.slice(list, 0, 3), false)
assert s1 == s
```


# License
This code is under the [Apache License v2](https://www.apache.org/licenses/LICENSE-2.0).  
