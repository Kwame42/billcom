crud_list =  [
  Billcom.Bill,
  Billcom.RecurringBill,
  Billcom.VendorCredit,
  Billcom.BillCredit,
  Billcom.SentPay,
  Billcom.BillPay,
  Billcom.ApprovalPolicy,
  Billcom.ApprovalPolicyApprover,
  Billcom.VendCreditApprover,
  Billcom.BillApprover,
  Billcom.Invoice,
  Billcom.Customer,
  Billcom.CustomerContact
]

action_list = ["create", "read", "update", "delete", "undelete"]

for crud <- crud_list do
    def_list = for action <- action_list do
      quote do
	@doc """
	#{unquote(crud)}.#{unquote(action)} for bill.com api
	## Parameters: 
	conn - a connection strucure (see Billcom.login/0)
	data - data object to send for the object
	## return:
	success - result of the request
	fail - raise error
	"""	
	@spec unquote(:"#{action}")(map(), map()) :: any 
	def unquote(:"#{action}")(connection, data) do
	  json_file = String.slice("#{unquote(crud)}", String.length("Elixir.") + String.length("Billcom."), String.length("#{unquote(crud)}")) <> ".json"
	  conn = Billcom.update_map(connection, :conn_url, connection.api_url <> "/Crud/" <> String.capitalize(unquote(action)) <> "/" <> json_file)
	  
	  Billcom.create_body(conn, data)
	  |> Billcom.execute(conn)
	end
      end
    end
	
    Module.create(crud, def_list, Macro.Env.location(__ENV__))
end
