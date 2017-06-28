defmodule Magic.App do
  @moduledoc """
  Magic Supervisor
  """
  use Application
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Shotgun
      supervisor(Shotgun,[name: :shotgun]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Magic.Supervisor]
    Supervisor.start_link(children, opts)
  end

end