defmodule Response do
  @moduledoc "This is a HttpResponse struct"
  defstruct [:code, :headers, :cookie, :body, :data]
end
