defmodule Imageapi do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Imageapi.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Imageapi.Endpoint, []),
      # Start your own worker by calling: Imageapi.Worker.start_link(arg1, arg2, arg3)
      # worker(Imageapi.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Imageapi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Imageapi.Endpoint.config_change(changed, removed)
    :ok
  end
end
