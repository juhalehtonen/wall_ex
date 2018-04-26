defmodule WallExWeb.RoomChannelTest do
  use WallExWeb.ChannelCase
  alias WallExWeb.RoomChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{canvas_id: 123})
      |> subscribe_and_join(RoomChannel, "room:lobby")

    {:ok, socket: socket}
  end

  test "joining a 'private' room failes", %{socket: socket} do
    assert {:error, %{reason: "unauthorized"}} =
             subscribe_and_join(socket, RoomChannel, "room:accessdenied")
  end

  test "`clear` broadcasts to room:lobby", %{socket: socket} do
    push(socket, "clear", %{})
    assert_broadcast("clear", %{})
  end

  test "`draw` broadcasts to room:lobby", %{socket: socket} do
    push(socket, "draw", %{canvas_id: 123, lines: []})
    assert_broadcast("draw", %{canvas_id: 123, lines: []})
  end
end
