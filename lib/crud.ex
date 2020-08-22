crud_list = [
  "Vendor", "VendorBankAccount", "Bill", "RecurringBill",
  "VendorCredit", "BillCredit", "SentPay", "BillPay",
  "ApprovalPolicy", "ApprovalPolicyApprover", "VendCreditApprover", "BillApprover",
  "Invoice", "RecurringInvoice", "CreditMemo", "InvoiceCredit",
  "ReceivedPay", "RPConvFee", "Customer", "CustomerContact",
  "CustomerBankAccount", "User", "Profile", "BankAccount",
  "MoneyMovement", "ActgClass", "ChartOfAccount", "Department",
  "Employee", "Item", "Job", "Location",
  "PaymentTerm", "Organization"
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
	success - {:ok, val}
	fail - {:error, val}
	"""	
	@spec unquote(:"#{action}")(map(), map()) :: any 
	def unquote(:"#{action}")(connection, data) do
	  json_file = unquote(crud) <> ".json"
	  conn = Billcom.update_map(connection, :conn_url, connection.api_url <> "/Crud/" <> String.capitalize(unquote(action)) <> "/" <> json_file)
	  Billcom.create_body(conn, data)
	  |> Billcom.execute(conn)
	end
      end
    end
	
    Module.create(String.to_atom("Elixir.Billcom.#{crud}"), def_list, Macro.Env.location(__ENV__))
end
