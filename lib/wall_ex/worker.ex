defmodule WallEx.Worker do
  @moduledoc """
  Worker GenServer responsible for initializing ETS-based storage and running a
  periodical check for expiring drawings.
  """
  use GenServer
  alias WallEx.Storage

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  GenServer.init/1 callback. Used to create the Storage (ETS table) on startup.
  """
  def init(state) do
    Storage.init()
    schedule_expiration()
    {:ok, state}
  end

  def handle_info(:expiration, state) do
    IO.puts("Clearing expired drawings...")
    Storage.delete_expiring()
    schedule_expiration()
    {:noreply, state}
  end

  defp schedule_expiration() do
    Process.send_after(self(), :expiration, 5_000)
  end
end
