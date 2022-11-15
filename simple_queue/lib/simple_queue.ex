defmodule SimpleQueue do
  use GenServer

  @doc """
  After the supervisor has started it must know how to
  start/stop/restart its children

  Each child module should have a `child_spec/1` function
  to define these behaviours
  """
  def child_spec(opts) do
    %{
      # Required. Used by the supervisor to identify the child specification
      id: SimpleQueue,
      # Required. The module/function/arguments to call when started by
      # the supervisor
      start: {__MODULE__, :start_link, [opts]},
      # Optional. The child's behaviour during shutdown
      shutdown: 5_000,
      # Optional. Approach for handling child process crashes
      restart: :permanent,
      # Optional. Either `:worker` or `:supervisor`. Defaults to `:worker`
      type: :worker
    }
  end

  def init(state), do: {:ok, state}

  # asynchronous functions
  def handle_cast({:enqueue, item}, state), do: {:noreply, [item | state]}

  # synchronous functions
  def handle_call(:queue, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:dequeue, _from, [item | state]) do
   {:reply, item, state}
  end

  def handle_call(:dequeue, _from, []) do
    {:reply, nil, []}
  end

  # Client API
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def dequeue() do
    GenServer.call(__MODULE__, :dequeue)
  end

  def queue() do
    GenServer.call(__MODULE__, :queue)
  end

  def enqueue(item) do
    GenServer.cast(__MODULE__, {:enqueue, item})
  end
end
