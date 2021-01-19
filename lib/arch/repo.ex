defmodule Arch.Repo do
  use Ecto.Repo,
    otp_app: :arch,
    adapter: Ecto.Adapters.Postgres
end
