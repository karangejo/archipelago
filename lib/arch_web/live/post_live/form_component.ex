defmodule ArchWeb.PostLive.FormComponent do
  use ArchWeb, :live_component

  alias Arch.Timeline
  alias Arch.Timeline.Post

  @impl true
  def mount(socket) do
   {:ok, allow_upload(socket, :file, accept: ~w(.png .jpeg .jpg .mp3 .zip .doc), max_entries: 10)}
  end

  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset = Timeline.change_post(post)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :file, ref)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Timeline.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  defp save_post(socket, :edit, post_params) do
    post = put_file_urls(socket, socket.assigns.post)
    case Timeline.update_post(post, post_params, &consume_files(socket, &1)) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_post(socket, :new, post_params) do
    post = put_file_urls(socket, %Post{})
    case Timeline.create_post(socket.assigns.current_user, post, post_params, &consume_files(socket, &1)) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  defp put_file_urls(socket, %Post{} = post) do
    {completed, []  } = uploaded_entries(socket, :file)
    urls =
      for entry <- completed do
        IO.inspect entry
        Routes.static_path(socket,"/uploads/#{entry.uuid}.#{entry.client_name}")
      end
    %Post{ post | file_urls: urls}
  end

  def consume_files(socket, %Post{} = post) do
    consume_uploaded_entries(socket, :file, fn meta, entry ->
      dest = Path.join("priv/static/uploads","#{entry.uuid}.#{entry.client_name}")
      File.cp!(meta.path, dest)
    end)
    {:ok, post}
  end

end
