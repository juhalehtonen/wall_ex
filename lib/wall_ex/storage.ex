defmodule WallEx.Storage do
  import Ex2ms
  @drawings_table :wallex_drawings

  @doc """
  Create ETS table if one does not already exist.
  Returns either an atom (:ok presumably, TODO: verify) or an Erlang Table ID.
  """
  @spec init() :: atom() | :ets.tid()
  def init do
    if :ets.info(@drawings_table) == :undefined do
      :ets.new(@drawings_table, [:named_table, :duplicate_bag, :public, read_concurrency: true])
    end
  end

  @doc """
  Delete all objects in the ETS table.
  """
  @spec destroy() :: true
  def destroy do
    :ets.delete_all_objects(@drawings_table)
  end

  @doc """
  Given a drawing, insert it to ETS.
  """
  @spec insert_drawing(map()) :: boolean()
  def insert_drawing(drawing) do
    :ets.insert_new(
      @drawings_table,
      {{drawing.timestamp, drawing.canvas_id}, drawing.lines}
    )
  end

  def get_expiring do
    current_timestamp = :os.system_time(:nano_seconds)

    f =
      fun do
        {{timestamp, _canvas_id}, lines} when timestamp + 10_000_000_000 < ^current_timestamp ->
          lines
      end

    :ets.select(@drawings_table, f)
  end

  @doc """
  Get all drawings from ETS.
  """
  @spec get_drawings() :: [any()]
  def get_drawings do
    :ets.match(@drawings_table, :"$1")
  end
end
