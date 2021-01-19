defmodule ArchWeb.PostLive.PostComponent do
  use ArchWeb, :live_component

  def mount(_params, _session, socket) do
    {:noreply, assign(socket, :show_photo_gallery, false)}
  end
  def handle_event("show-post-photo-gallery", _params, socket) do
    {:noreply, assign(socket, :show_photo_gallery, true)}
  end
end
