defmodule WallEx.Storage do
  @post_table :wallex_drawings

  @doc """
  Create ETS table if one does not already exist.
  Returns either an atom (:ok presumably, TODO: verify) or an Erlang Table ID.
  """
  @spec init() :: atom() | :ets.tid()
  def init do
    if :ets.info(@post_table) == :undefined do
      :ets.new(@post_table, [:named_table, :duplicate_bag, :public, read_concurrency: true])
    end
  end

  @doc """
  Delete all objects in the ETS table.
  """
  @spec destroy() :: true
  def destroy do
    :ets.delete_all_objects(@post_table)
  end

  @doc """
  Given a drawing, insert it to ETS.
  Sample of a drawing:
  %{key: %{canvas_id: canvas_id, timestamp: timestamp},
    lines: lines
  }
  """
  @spec insert_drawing(map()) :: boolean()
  def insert_drawing(drawing) do
    :ets.insert_new(@post_table, {{drawing.timestamp, drawing.canvas_id}, drawing.lines})
  end

  @doc """
  Get all drawings from ETS.
  """
  @spec get_drawings() :: [any()]
  def get_drawings do
    :ets.match(@post_table, :"$1")
  end
end
