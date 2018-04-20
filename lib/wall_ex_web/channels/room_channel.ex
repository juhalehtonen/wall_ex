defmodule WallExWeb.RoomChannel do
  use Phoenix.Channel

  # To intercept outgoing "draw" events
  intercept(["draw"])

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("draw", %{"canvas_id" => canvas_id, "lines" => lines}, socket) do
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
