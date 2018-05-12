defmodule WallEx.Storage do
  import Ex2ms
  @drawings_table :wallex_drawings
  @expiration_time Application.get_env(:wall_ex, :storage_expiration_time)

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

  @doc """
  Gets and deletes all expiring objects from the ETS table. Expiration time is
  defined in nanoseconds through the Application configuration.

  Returns a list of `true` for each deleted drawing. An empty list therefore
  indicates that no drawings were expired and deleted.
  """
  @spec delete_expiring() :: [] | [true]
  def delete_expiring do
    fun = expiration_match_spec()
    objs = :ets.select(@drawings_table, fun)

    Enum.map(objs, fn obj ->
      :ets.delete_object(@drawings_table, obj)
    end)
  end

  @doc """
  Get all drawings from ETS.
  """
  @spec get_drawings() :: [any()]
  def get_drawings do
    :ets.match(@drawings_table, :"$1")
  end

  # Construct match specification for expiration checking
  defp expiration_match_spec do
    current_timestamp = :os.system_time(:nano_seconds)

    fun do
      {{timestamp, _canvas_id}, lines} = obj
      when timestamp + ^@expiration_time < ^current_timestamp ->
        obj
    end
  end
end
