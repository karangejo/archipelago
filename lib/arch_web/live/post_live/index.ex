defmodule ArchWeb.PostLive.Index do
  use ArchWeb, :live_view

  alias Arch.Timeline
  alias Arch.Timeline.Post
  alias Arch.Accounts

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Timeline.subscribe()

    socket = assign(socket, :posts, list_posts())
    case Map.fetch(session, "user_token") do
      {:ok, token} ->
        user = Accounts.get_user_by_session_token(token)
        {:ok, assign(socket, current_user: user)}
      :error ->
        {:ok, socket}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Timeline.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Timeline")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts())}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  @impl true
  def handle_info({:post_deleted, _post}, socket) do
    {:noreply, update(socket, :posts, fn _posts -> list_posts() end)}
  end

  defp list_posts do
    Timeline.list_posts()
  end
end
