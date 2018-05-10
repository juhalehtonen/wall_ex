defmodule WallExWeb.PageView do
  use WallExWeb, :view
  @expiration_time Application.get_env(:wall_ex, :storage_expiration_time)

  @doc """
  Converts storage expiration time from nanoseconds to seconds, and divides by 60
  to get a minute count
  """
  def get_expiration_time do
    (System.convert_time_unit(@expiration_time, :nanoseconds, :seconds) / 60) |> round()
  end
end
