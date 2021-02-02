defmodule ArchWeb.PhotoGallery do
  use ArchWeb, :live_view

  alias Arch.Timeline
  alias Arch.PhotoMetadata

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    post = Timeline.get_post!(id)
    metadata_list =
      for url <- post.photo_urls do
        {:ok, metadata_string} = PhotoMetadata.get_metadata(url)
        metadata_string
      end

    socket =
      socket
      |> assign(:post, post)
      |> assign(:metadata_list, metadata_list)

    {:ok, socket}
  end


end
