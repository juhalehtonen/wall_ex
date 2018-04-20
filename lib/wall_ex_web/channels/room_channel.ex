defmodule WallExWeb.RoomChannel do
  use Phoenix.Channel
  alias WallEx.Storage

  # To intercept outgoing "draw" events
  intercept(["draw"])

  def join("room:lobby", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info(:after_join, socket) do
    drawings = for [{_, item}] <- Storage.get_drawings(), do: item

    for drawing <- drawings do
      lines = drawing["lines"]
      push(socket, "draw", %{lines: lines})
    end

    {:noreply, socket}
  end

  def handle_in("draw", %{"canvas_id" => canvas_id, "lines" => lines} = drawing, socket) do
    IO.puts("Storing drawing..")
    IO.inspect(drawing)
    Storage.insert_drawing(drawing)
    broadcast!(socket, "draw", %{canvas_id: canvas_id, lines: lines})
    {:noreply, socket}
  end

  def handle_out("draw", %{canvas_id: canvas_id, lines: lines}, socket) do
    # Pages draw locally to their own canvas before sending out draw events so
    # we don't rebroadcast them the event they sent the server.
    if canvas_id === socket.assigns.canvas_id do
      {:noreply, socket}
    else
      push(socket, "draw", %{lines: lines})
      {:noreply, socket}
    end
  end
end
