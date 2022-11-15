defmodule SimpleQueue.Application do
  @moduledoc false

  use Application

  @impl true
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      {SimpleQueue, [1, 2, 3]}
    ]

    # https://elixirschool.com/en/lessons/advanced/otp_supervisors
    opts = [
      # strategy: :one_for_all, # restart all child processes in the event of a failure
      # strategy: :rest_for_one, # restart the failed processes and any process started after it
      strategy: :one_for_one, # only restart the failed child process
      name: SimpleQueue.Supervisor
    ]
    Supervisor.start_link(children, opts)
  end
end
