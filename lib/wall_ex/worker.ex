defmodule WallEx.Worker do
  use GenServer

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  GenServer.init/1 callback. Used to create the Storage (ETS table) on startup.
  """
  def init(state) do
    WallEx.Storage.init()
    {:ok, state}
  end
end
