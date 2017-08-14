# Magic


[![Build Status](https://travis-ci.org/pivstone/Magic.svg?branch=master)](https://travis-ci.org/pivstone/Magic)
[![Coverage Status](https://coveralls.io/repos/github/pivstone/Magic/badge.svg?branch=master)](https://coveralls.io/github/pivstone/Magic?branch=master)

Magic is a set of common libraries for personal daily coding. 
It's contained randmom, system cmd, http request, IoC(beta).


## System cmd

### Run

```sh
iex> import Magic
iex> ~q(echo 123)
{:ok, ["123"]}
```

### Async Run
```sh
iex(1)> import Magic
Magic
iex(2)> ~b(echo 123)
#Port<0.5385>
iex(3)> flush()
{#Port<0.5385>, {:data, "123\n"}}
{#Port<0.5385>, {:exit_status, 0}}
:ok
```

## Random String

```sh
iex> Random.random()
"9nNc2OaQJowEEucW"

iex> Random.random(32)
"SpMkGZ5fvapMlvA8ALG8n3YQShPm91wB"
```

## Find who implemented `Mix.SCM`

```sh
iex> Shotgun.find(Mix.SCM)
[Hex.SCM, Mix.SCM.Path, Mix.SCM.Git]

iex> Shotgun.find(ABC)
[]
```

## Http Request

```sh
iex> {:ok, rsp} = Http.get("https://registry-1.docker.io/v2/")
iex> rsp.data
%{"errors" => [%{"code" => "UNAUTHORIZED", "detail" => nil, "message" => "authentication required"}]}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `magic` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:magic, "~> 0.2.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/magic](https://hexdocs.pm/magic).

