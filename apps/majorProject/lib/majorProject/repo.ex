defmodule MajorProject.Repo do
  use Ecto.Repo,
    otp_app: :majorProject,
    adapter: Ecto.Adapters.MyXQL
end
