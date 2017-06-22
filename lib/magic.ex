defmodule Magic do
  @doc """
  捕获所有异常，转化为正常输出
  注意：这样做 无法进行 递归优化，性能影响比较严重
  """
  defmacro defp_protected(head, body) do
    quote do
      defp unquote(head) do
        try do
          unquote(body[:do])
        catch
          reason -> {:error, reason}
        rescue
          reason -> {:error, reason}
        end
      end
    end
  end
  @doc """

  执行命令,如果命令不存在则会报错，或者命令执行失败

  example:
  iex> import Magic
  iex> ~x(echo 123)
  {:ok, ["123"]}

  iex> import Magic
  iex> ~x(. ls)c
  {:ok, ["README.md", "_build", "config", "lib", "magic.iml", "mix.exs",
                     "test"]}

  c = CD, 在指定路径执行命令

  """
  def sigil_x(string, mod \\ []) do
    execute(string, mod)
  end

  @doc """
  执行命令,如果命令不存或者命令执行失败 不会抛错 而是返回 {:error,reason}
  iex> import Magic
  iex> ~q(echo 123)
  {:ok, ["123"]}
  """
  def sigil_q(term ,modifiers) do
    try do
      execute(term, modifiers)
    catch
      reason -> {:error, reason}
    rescue
      reason -> {:error, reason}
    end
  end

  def sigil_b(string, []) do
     sigil_b(string, [?s])
  end

  def sigil_b(string, [mod]) when mod == ?s do
    async_run(string)
  end

  def sigil_b(string,[mod]) when mod == ?c do
    [cd|cmd] = String.split(string, " ", parts: 2)
    async_run(hd(cmd), [cd: cd])
  end

  defp async_run(cmd, opts \\ [])do
    Port.open({:spawn, cmd}, [:binary, :exit_status, {:parallelism, true}, :stderr_to_stdout] ++ opts)
  end

  defp execute(string, [])do
    execute(string, [?s])
  end

  defp execute(string, [mod]) when mod == ?s do
    [cmd|args] = String.split(string)
    run(cmd, args)
  end
  defp execute(string, [mod]) when mod == ?c do
    [cd|other] = String.split(string)
    [cmd|args] = other
    run(cmd, args, [cd: cd])
  end

  defp execute(_string,_mods) do
    raise ArgumentError, "modifier must be one of: c, s"
  end

  defp run(cmd, args, opts \\ []) do
    case System.cmd(cmd, args, [stderr_to_stdout: true] ++ opts) do
      {output, 0} ->
        {:ok, output |> String.split("\n", trim: true)}
      {reason, _} ->
        throw reason
      reason ->
        throw reason
    end
  end
end