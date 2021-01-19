defmodule Arch.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :user_email, :string
      add :body, :string
      add :up_votes, :integer
      add :down_votes, :integer
      add :user_id, references(:users), on_delete: :delete_all

      timestamps()
    end

  end
end
