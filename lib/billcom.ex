defmodule Billcom do
  defmodule Conn do
    defstruct dev_key: "", org_id: "", password: "", user_name: "", session_id: "", api_url: ""
  end

  defp get_conf do
    configuration = Application.fetch_env!(:billcom, :api)
    api_url = cond do
      Map.has_key?(configuration, :prod) == true -> "https://api.bill.com/api/v2/"
      true -> "https://api-sandbox.bill.com/api/v2"
    end
    
    %Conn{
      dev_key: configuration.devKey,
      org_id: configuration.orgId,
      password: configuration.password,
      user_name: configuration.userName,
      api_url: api_url
    }
  end

  @json_url [
    {:login, "Login.json"},
    {:logout, "Logout.json"}
  ]
  
  for {token, json} <- @json_url do
    defp update_conn_url(conn, unquote(token)), do: update_map(conn, :conn_url, conn.api_url <> "/" <> unquote(json))
  end

  defp check_answer(answer) do
    cond do
      Map.fetch!(answer, "response_status") == 0 -> answer
      true -> raise "Error"
    end
  end
  
  defp execute(body, conn) do
    result = HTTPoison.post(conn.conn_url, URI.encode_query(body), %{"Content-Type" => "application/x-www-form-urlencoded"})
    answer = case result do
      {:ok, answer} -> answer
      _ -> raise "Cannot execute request"
    end
    answer
    |> Map.fetch!(:body)
    |> Poison.decode!()
    |> check_answer()      
  end

  defp create_body(conn, :no_session) do
    %{
      devKey: conn.dev_key,
      orgId: conn.org_id,
      password: conn.password,
      userName: conn.user_name
    }
  end
  
  defp create_body(conn) do
    %{
      devKey: conn.dev_key,
      orgId: conn.org_id,
      password: conn.password,
      userName: conn.user_name,
      sessionId: conn.session_id
    }
  end

  defp key_to_atom(key) do
    key
    |> String.replace(~r/([A-Z]\w+)/, "_\\1")
    |> String.downcase()
    |> String.to_atom()
  end
  
  defp update_conn(_, conn, []) do
    conn
  end
  
  defp update_conn(data, conn, [val | last]) do
    value = Map.fetch!(data, "response_data") |> Map.fetch!(val)
    new_conn = update_map(conn, key_to_atom(val), value)
    update_conn(data, new_conn, last)
  end

  defp update_conn(data, conn, val) do
    Map.update(conn, key_to_atom(val), Map.fetch(data, val), fn _ -> Map.fetch(data, val) end)
  end

  defp update_map(map, key, val) do
    Map.update(map, key, val, fn _ -> val end)
  end

  def login do
    conn = get_conf()
    |> update_conn_url(:login)
    HTTPoison.start()
    create_body(conn, :no_session)
    |> execute(conn)
    |> update_conn(conn, ["sessionId", "usersId"])
  end

#  def logout(conn) do
#    HTTPoison.stop()
#    conn
#  end

  def list_orgs(conn) do
    conn
  end

  def get_list(conn) do
    conn
  end

  def create(conn) do
    conn
  end

  def read(conn) do
    conn
  end

  def update(conn) do
    conn
  end

  def approve(conn) do
    conn
  end

  def pay_bill(conn) do
    conn
  end

  def record_bill_payed (conn) do
    conn
  end

  def upload_attachment(conn) do
    conn
  end

  def get_session_id(conn) do
    conn
  end

  def set_session_id(conn) do
    conn
  end

  def get_org_id(conn) do
    conn
  end

  def set_org_id(conn) do
    conn
  end

  def get_dev_key(conn) do
    conn
  end

  def set_dev_key(conn) do
    conn
  end

  def get_login(conn) do
    conn
  end

  def set_login(conn) do
    conn
  end

  def get_password(conn) do
    conn
  end

  def set_password(conn) do
    conn
  end
end
