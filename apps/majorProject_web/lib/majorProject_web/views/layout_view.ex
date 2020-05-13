defmodule MajorProjectWeb.LayoutView do
  use MajorProjectWeb, :view

  def new_locale(conn, locale, language_title) do
    "<a href=\"#{Routes.session_path(conn, :new, locale: locale)}\">#{language_title}</a>" |> raw
  end
end
