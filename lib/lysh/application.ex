defmodule Lysh.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LyshWeb.Telemetry,
      Lysh.Repo,
      {DNSCluster, query: Application.get_env(:lysh, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Lysh.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Lysh.Finch},
      # Start a worker by calling: Lysh.Worker.start_link(arg)
      # {Lysh.Worker, arg},
      # Start to serve requests, typically the last entry
      LyshWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lysh.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LyshWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
