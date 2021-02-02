defmodule Arch.PhotoMetadata do
  def get_metadata(img_path) do
    case Exexif.exif_from_jpeg_file("priv/static" <> img_path) do
      {:ok, info} ->
        metadata_string =
          info.exif
          |> Enum.map(fn {key, value} -> if !is_list(value) do "#{key}: #{value} \n" else "" end end)
          |> Enum.reduce(fn x, acc -> x <> acc end)

          {:ok, metadata_string}

          _ ->
        {:error, "could not extract metadata"}
    end
  end
end
