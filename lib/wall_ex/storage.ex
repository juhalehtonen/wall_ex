defmodule WallEx.Storage do
  @post_table :wallex_drawings

  def init do
    # Only create tables if they don't exist already
    if :ets.info(@post_table) == :undefined do
      :ets.new(@post_table, [:named_table, :duplicate_bag, :public, read_concurrency: true])
    end
  end

  @doc """
  Given a drawing, insert it to ETS.
  """
  def insert_drawing(%{"canvas_id" => canvas_id, "lines" => lines} = drawing) do
    :ets.insert_new(@post_table, {:rand.uniform(100_000_000_000), drawing})
  end

  @doc """
  Get all drawings.
  """
  def get_drawings do
    :ets.match(@post_table, :"$1")
  end
end
