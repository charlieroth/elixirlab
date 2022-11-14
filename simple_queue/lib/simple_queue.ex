# https://elixirschool.com/en/lessons/advanced/otp_supervisors
defmodule SimpleQueue do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def handle_cast({:enqueue, item}, state), do: {:noreply, [item | state]}
  def handle_call(:queue, _from, state), do: {:reply, state, state}
  def handle_call(:dequeue, _from, [item | state]), do: {:reply, item, state}
  def handle_call(:dequeue, _from, []), do: {:reply, nil, []}

  def enqueue(item), do: GenServer.cast(__MODULE__, {:enqueue, item})
  def dequeue(), do: GenServer.call(__MODULE__, :dequeue)
  def queue(), do: GenServer.call(__MODULE__, :queue)
end
