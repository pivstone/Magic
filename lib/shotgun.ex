defmodule Shotgun do
  @moduledoc """
  The `Shotgun` provides function to found and execute IoC moudles
  """
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: :shotgun)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:seek, name}, _from, state) do
    if Map.has_key?(state, name) do
      {:reply, Map.get(state, name), state}
    else
      data = seek(name)
      {:reply, data, Map.put(state, name, data)}
    end
  end

  @doc """
  Find the modules that are mpelemented specific hehaviour

  ### Exmaple

      iex> Shotgun.find(Mix.SCM)
      [Hex.SCM, Mix.SCM.Path, Mix.SCM.Git]

      iex> Shotgun.find(ABC)
      []
  """
  def find(name) do
    GenServer.call(:shotgun, {:seek, name})
  end

  defp seek(name) do
    :erlang.loaded() -- [:elixir_compiler_3, :elixir_compiler_2, :elixir_compiler_1]
    |> Enum.map(fn x ->
      :erlang.get_module_info(x)
     end)
    |> Enum.filter(fn x->
      match(x, name)
     end)
    |> Enum.map(&name/1)
  end

  defp match([_|[_|[{:attributes,[_|[behaviour: behaviours]]}|_]]], target) do
    Enum.member?(behaviours, target)
  end

  defp match(_module_info, _target) do
    false
  end

  defp name([{:module, name}|_]), do: name
end