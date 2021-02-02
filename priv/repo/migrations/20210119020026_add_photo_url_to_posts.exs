defmodule Arch.Repo.Migrations.AddPhotoUrlToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :file_urls, {:array, :string}, null: false, default: []
    end
  end
end
