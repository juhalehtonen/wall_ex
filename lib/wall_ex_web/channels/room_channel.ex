defmodule WallExWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("draw", %{"line" => line}, socket) do
    broadcast!(socket, "draw", %{line: line})
    {:noreply, socket}
  end
end
