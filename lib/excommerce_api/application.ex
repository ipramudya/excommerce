defmodule ExcommerceApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExcommerceApiWeb.Telemetry,
      ExcommerceApi.Repo,
      {DNSCluster, query: Application.get_env(:excommerce_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ExcommerceApi.PubSub},
      # Start a worker by calling: ExcommerceApi.Worker.start_link(arg)
      # {ExcommerceApi.Worker, arg},
      # Start to serve requests, typically the last entry
      ExcommerceApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExcommerceApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExcommerceApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
