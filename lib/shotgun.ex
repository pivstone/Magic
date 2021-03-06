defmodule Shotgun do
  @moduledoc """
  The `Shotgun` is a IoC Helper. It provides function to found and execute moudles
  """
  use GenServer

  def start_link do
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
    :erlang.loaded()
    |> Enum.filter(fn x ->
      function_exported?(x, :module_info, 0)
    end)
    |> Enum.map(fn x ->
      apply(x, :module_info, [])
    end)
    |> Enum.filter(fn x ->
      match(x, name)
    end)
    |> Enum.map(&name/1)
  end

  defp match([_ | [_ | [{_, [_ | [behaviour: beas]]} | _]]], target),
    do: Enum.member?(beas, target)

  defp match(_module_info, _target), do: false

  defp name([{:module, name} | _]), do: name
end
