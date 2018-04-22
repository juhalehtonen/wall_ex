defmodule WallEx do
  @moduledoc """
  WallEx keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def configure_production_url do
    app_name = System.get_env("HEROKU_APP_NAME")

    case String.contains?(app_name, "-pr-") do
      false -> "wallex.herokuapp.com"
      true -> app_name <> ".herokuapp.com"
    end
  end
end
