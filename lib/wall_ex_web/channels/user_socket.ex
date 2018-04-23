defmodule WallExWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel("room:*", WallExWeb.RoomChannel)

  ## Transports
  transport(
    :websocket,
    Phoenix.Transports.WebSocket,
    timeout: 45_000,
    check_origin: generate_origins()
  )

  def generate_origins do
    gens = Enum.map(1..100, fn num -> "https://wallex-pr-#{num}.herokuapp.com" end)
    ["https://wallex.herokuapp.com" | gens]
  end

  # transport :longpoll, Phoenix.Transports.LongPoll

  @doc """
  Return the system time to be used as a simple canvas ID.
  """
  def canvas_id do
    System.os_time()
  end

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"canvas_id" => canvas_id}, socket) do
    {:ok, assign(socket, :canvas_id, String.to_integer(canvas_id))}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     WallExWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
