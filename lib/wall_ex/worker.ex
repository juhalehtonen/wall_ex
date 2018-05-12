defmodule WallEx.Worker do
  @moduledoc """
  Worker GenServer responsible for initializing ETS-based storage and running a
  periodical check for expiring drawings.
  """
  use GenServer
  alias WallEx.Storage
  @expiration_check_period Application.get_env(:wall_ex, :storage_expiration_check_period)

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

  @doc """
  Clear expired drawings and set up a new round of expiration. Only broadcasts
  an expiration to clients if something was expired. In other words, if the
  Storage.delete_expiring/0 returns an empty list, do not bother updating the
  clients about this.
  """
  def handle_info(:expiration, state) do
    case Storage.delete_expiring() do
      [] ->
        :ok

      _ ->
        broadcast_expiration()
    end

    # Finally re-call the scheduling function to set up a new round of checking
    schedule_expiration()
    {:noreply, state}
  end

  defp schedule_expiration() do
    Process.send_after(self(), :expiration, @expiration_check_period)
  end

  defp broadcast_expiration do
    WallExWeb.Endpoint.broadcast("room:lobby", "expire", %{})
  end
end
