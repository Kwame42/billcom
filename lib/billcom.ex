defmodule Billcom do
  @moduledoc """
  Simple api library to connect to bill.com api

  config your bill.com connection:

  config :billcom, :api,
  %{
    devKey: "myDevKey",
    orgId: "myOrgId",
    password: "myPassword",
    userName: "myUsername"
  }

  Then use

  ...
  conn = Billcom.login
  Billcom.list_orgs(conn)
  ...
  """

  @doc """
  Login to bill.com api

  ## Parameters: 

  none - the module load it's configuration from config file

  ## return:

  success - {:ok, conn} where conn is an updated version of the conn passed in parameters with sessionId and usersId
  failure - raise error
  """
  @spec login! :: conn
  def login! do
    conn = get_conf()
    |> update_conn_url(:login)
    
    HTTPoison.start()
    case create_body(conn, :no_session) |> execute(conn) do
      {:ok, val} -> update_conn(val, conn, ["sessionId", "usersId"])
      {:error, val} -> raise "Error: cannot login: #{to_string(val)}"
    end
  end

  @doc """
  logout from Bill.com api

  ## Parameters: 

  conn - see login

  ## return:
  success - {:ok, val} where data are logout data
  failure - {:error, val} where date are failure reasons
  """
  @spec logout(conn) :: {atom(), map()}
  def logout(connection) do
    conn = update_conn_url(connection, :logout)
    
    create_body(conn) |> execute(conn)
  end

  @doc """
  Return the list of organisation associated with your account

  ## Parameters: 

  conn - see login

  ## return:
  success - {:ok, val} from where you can fetch organisation list (example: val |> Map.fetch!("response_data"))
  failure - {:error, val} where date are failure reasons
  """
  @spec list_orgs(conn()) :: {atom(), map()}
  def list_orgs(connection) do
    conn = update_conn_url(connection, :list_orgs)
    
    create_body(conn)
    |> execute(conn)
  end

  @doc """
  Check for the presence of a key in the result collections

  ## Parameters: 

  result - result of a api call
  key - the key you are looking for

  ## return:
  success - true
  failure - false

  """
  @spec has_key?(map(), String.t) :: atom()
  def has_key?(result, key) do
    result |> elem(1) |> Map.fetch!("response_data") |> Map.has_key?(key)
  end
    
  @doc """
  Return the value of a key in the result collections 

  ## Parameters: 

  result - result collection of a api call
  key - the key from which to return a value

  ## return:
  success - value
  failure - unkown behavior see has_key?

  """
  @spec get_val(map(), String.t) :: atom()
  def get_val(result, key) do
    result |> elem(1) |> Map.fetch!("response_data") |> Map.fetch!(key)
  end


  @api_function_list_data [
    "RecordAPPayment",
    "VoidAPPayment",
    "CancelAPPayment",
    "GetAPSummary",
    "GetDisbursementData",
    "ListPayments",
    "GetCheckImageData",
    "SetApprovers",
    "ListApprovers",
    "ListUserApprovals",
    "Approve",
    "Deny",
    "ClearApprovers",
    "SendInvoice",
    "MailInvoice",
    "ChargeCustomer",
    "RecordARPayment",
    "GetARSummary",
    "SetCustomerAuthorization",
    "GetProfilePermissions",
    "GetBankBalance",
    "SetBankBalance",
    "UploadAttachment",
    "SendMessage",
    "GetDocumentPages",
    "ListMessage",
    "NetworkSearch",
    "SendVendorInvite",
    "SendInvite",
    "LargeBillerSearch",
    "GetLargeBillerPaymentAddress",
    "ConnectLargeBillerAsVendor",
    "GetNetworkStatus",
    "CancelInvite",
    "DisconnectVendorFromNetwork",
    "DisconnectCustomerFromNetwork",
# "GetSessionInfo"
    "MFAChallenge",
    "MFAAuthenticate",
    "MFAStatus",
    "GetObjectUrl",
#/List/<Object Name>.json    "",
    "SearchEntity",
#CurrentTime    "",
#ListOrgs    "",
#/Bulk/Crud/OPERATION/ENTITY    "",
    "GetEntityMetadata"
  ]

  for function <- @api_function_list_data do
    function_name =
      function
      |> String.replace(~r/([A-Z][a-z]+)/, "_\\1")
      |> String.downcase()
      |> String.slice(1..-1)
    
    @doc """
    #{function} for bill.com api
    ## Parameters: 
    conn - a connection structure (see Billcom.login/0)
    data - data object to send for the object
    ## return:
    success - {:ok, val}
    fail - {:error, val}
    """	
    @spec unquote(:"#{function_name}")(map(), map()) :: any 
    def unquote(:"#{function_name}")(connection, data) do
      conn = Billcom.update_map(connection, :conn_url, connection.api_url <> "#{unquote(function)}.json")
      Billcom.create_body(conn, data)
      |> Billcom.execute(conn)
    end
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

  @type conn :: %{
    dev_key: String.t,
    org_id: String.t,
    password: String.t,
    user_name: String.t,
    session_id: String.t,
    api_url: String.t,
    conn_url: String.t
  }
  
  defmodule Conn do
    defstruct dev_key: "", org_id: "", password: "", user_name: "", session_id: "", api_url: ""
  end
  
  is_struct? = fn atom -> atom == :__struct__ end
  
  for field <- Conn.__struct__() |> Map.keys(), not is_struct?.(field) do
    field_str = Atom.to_string(field)
    @doc """
    get_#{field_str} get object value #{field_str}
    
    ## Parameters: 
    
    conn - actual connexion structure
    
    ## return:
    #{field_str} value
    """
    @spec unquote(:"get_#{field_str}")(conn) :: String.t
    
    def unquote(:"get_#{field_str}")(conn) do
      Map.fetch!(conn, unquote(field))
    end

    @doc """
    set_#{field_str} set object "#{field_str}" value
    
    ## Parameters: 
    
    conn - actual connexion structure
    val - value of the object
    
    ## return:
    new conn strucutre with #{field_str} set to val
    """
    @spec unquote(:"set_#{field_str}")(conn, String.t) :: String.t
    
    def unquote(:"set_#{field_str}")(conn, val) do
      Map.put(conn, unquote(field), val)
    end
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
    {:logout, "Logout.json"},
    {:list_orgs, "ListOrgs.json"},
    {:approve, "Approve.json"},
    {:pay_bill, "PayBill.json"},
    {:record_ap_payment, "RecordAPPayment.json"},
    {:upload_attachment, "UploadAttachment.json"}
  ]
  
  for {token, json} <- @json_url do
    defp update_conn_url(conn, unquote(token)), do: update_map(conn, :conn_url, conn.api_url <> "/" <> unquote(json))
  end
  
  defp check_answer(answer) do
    cond do
      Map.fetch!(answer, "response_status") == 0 -> {:ok, answer}
      Map.fetch!(answer, "response_status") != 0 -> {:error, answer}
    end
  end
  
  def execute(body, conn) do
    result = HTTPoison.post(conn.conn_url, URI.encode_query(body), %{"Content-Type" => "application/x-www-form-urlencoded"})
    case result do
      {:ok, answer} -> answer
      _ -> raise "Cannot execute request"
    end
    |> Map.fetch!(:body)
    |> Poison.decode!()
    |> check_answer()      
  end

  def create_body(conn, :no_session) do
    %{
      devKey: conn.dev_key,
      orgId: conn.org_id,
      password: conn.password,
      userName: conn.user_name
    }
  end

  def create_body(conn, data) do
    create_body(conn)
    |> Map.put_new(:data, Poison.encode!(data))
  end

  
  def create_body(conn) do
    create_body(conn, :no_session)
    |> Map.put_new(:sessionId, conn.session_id)
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

  def update_map(map, key, val) do
    Map.update(map, key, val, fn _ -> val end)
  end
end
