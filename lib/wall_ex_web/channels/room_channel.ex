defmodule WallExWeb.RoomChannel do
  use Phoenix.Channel
  alias WallEx.Storage

  # To intercept outgoing "draw" events
  intercept(["draw"])

  def join("room:lobby", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  @spec join(String.t(), struct(), struct()) :: {:error, map()}
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  @doc """
  Load existing drawings and send them to the joining client.
  """
  def handle_info(:after_join, socket) do
    drawings = for [{_, item}] <- Storage.get_drawings(), do: item
    lines = Enum.map(drawings, fn drawing -> drawing end) |> List.flatten()

    # Go through `lines` and step through every 500 of them.
    # Returns a list of lists, so we can enumerate through it to push.
    batches = Enum.chunk_every(lines, 500)
    # Push each batch to the client
    Enum.each(batches, fn lines -> push(socket, "load", %{lines: lines}) end)

    {:noreply, socket}
  end

  def handle_in("clear", _payload, socket) do
    Storage.destroy()
    broadcast!(socket, "clear", %{})
    {:noreply, socket}
  end

  def handle_in("draw", %{"canvas_id" => canvas_id, "lines" => lines}, socket) do
    timestamp = :os.system_time(:nano_seconds)
    Storage.insert_drawing(%{timestamp: timestamp, canvas_id: canvas_id, lines: lines})
    broadcast!(socket, "draw", %{canvas_id: canvas_id, lines: lines})
    {:noreply, socket}
  end

  @doc """
  Intercept the outgoing draw event and filter it out if the receiver would be
  the sender. Pages draw locally to their own canvas before sending out draw events
  so we don't rebroadcast them the event they sent the server.
  """
  def handle_out("draw", %{canvas_id: canvas_id, lines: lines}, socket) do
    if canvas_id === socket.assigns.canvas_id do
      {:noreply, socket}
    else
      push(socket, "draw", %{lines: lines})
      {:noreply, socket}
    end
  end
end
