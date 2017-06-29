defmodule Random do
  @moduledoc """
  The `Random` provides functions that about random function
  """

  @doc """
  Random generate a 16 length string

  ## Examples

      iex> Random.random()
      "9nNc2OaQJowEEucW"

      iex> Random.random(32)
      "SpMkGZ5fvapMlvA8ALG8n3YQShPm91wB"

  """
  @spec random :: String.t
  def random, do: random 16

  @doc """
  Random generate a specifc length string

  Notes: size must be an Integer and greater than ZERO

      iex> Random.random(-1)
      ** (ArgumentError) size must be greater than ZERO, got -1

      iex> Random.random("abd")
      ** (ArgumentError) size must be Integer, got abd
  """
  @spec random(size :: non_neg_integer) :: String.t
  def random(size) when is_integer(size) and size > 0, do: size |> :crypto.strong_rand_bytes |> Base.url_encode64 |> binary_part(0, size)
  def random(size) when is_integer(size), do: raise ArgumentError, "size must be greater than ZERO, got #{size}"
  def random(size), do: raise ArgumentError, "size must be Integer, got #{size}"
end
