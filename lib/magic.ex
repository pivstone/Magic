defmodule Magic do
  @moduledoc """
  The `Magic` module provides convenience [sigil](https://elixir-lang.org/getting-started/sigils.html) wrapper for Port cmd
  """
  @doc """
  The macros catch all error and exception,

  transform them to normal output

  Note: There are may have some performance issues

  ## Examples:

      import Magic
      defp_protected oops! do
       raise ArgumentError, "oops!"
      end

      oops!() == {:error, %ArgumentError{message: "oops!"}}
  """
  defmacro defp_protected(head, body) do
    quote do
      defp unquote(head) do
        unquote body[:do]
      catch
        reason -> {:error, reason}
      rescue
        reason -> {:error, reason}
      end
    end
  end
  @doc """
  EN: Execute a specific cmd, will raise a exception if the cmd don't exists or execute failed
  CN: 执行命令,如果命令不存在则会报错，或者命令执行失败

  ## Examples:

      iex> import Magic
      iex> ~x(echo 123)
      {:ok, ["123"]}

      iex> import Magic
      iex> ~x(./lib ls)c
      {:ok, ["app.ex", "http.ex", "magic.ex", "random.ex", "response.ex", "shotgun.ex"]}

  c = CD,
  EN: change the current directory into a specific directory
  CN: 在指定路径执行命令

  """
  def sigil_x(string, mod \\ []) do
    execute string, mod
  end

  @doc """
  EN: Execute a specific cmd, when return {:error,reason} if the cmd don't exists or execute failed
  CN: 执行命令,如果命令不存或者命令执行失败 不会抛错 而是返回 {:error,reason}

  ## Examples:
      iex> import Magic
      iex> ~q(echo 123)
      {:ok, ["123"]}
  """
  def sigil_q(term, modifiers) do
    try do
      execute term, modifiers
    catch
      reason -> {:error, reason}
    rescue
      reason -> {:error, reason}
    end
  end

  @doc ~S"""
  Async Run cmd
  """
  def sigil_b(string, []) do
     sigil_b string, [?s]
  end

  def sigil_b(string, [mod]) when mod == ?s do
    async_run string
  end

  def sigil_b(string, [mod]) when mod == ?c do
    [cd|cmd] = String.split string, " ", parts: 2
    async_run hd(cmd), [cd: cd]
  end

  defp async_run(cmd, opts \\ [])do
    opts = [:binary,
            :exit_status,
            {:parallelism, true},
            :stderr_to_stdout] ++ opts
    Port.open {:spawn, cmd}, opts
  end

  defp execute(string, [])do
    execute string, [?s]
  end

  defp execute(string, [mod]) when mod == ?s do
    [cmd|args] = String.split string
    run cmd, args
  end

  defp execute(string, [mod]) when mod == ?c do
    [cd|other] = String.split string
    [cmd|args] = other
    run cmd, args, [cd: cd]
  end

  defp execute(_string, _mods) do
    raise ArgumentError, "modifier must be one of: c, s"
  end

  defp run(cmd, args, opts \\ []) do
    case System.cmd cmd, args, [stderr_to_stdout: true] ++ opts do
      {output, 0} ->
        {:ok, output |> String.split("\n", trim: true)}
      {reason, _} ->
        raise reason
    end
  end
end
