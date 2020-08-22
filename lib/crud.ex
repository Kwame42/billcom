##
## Copyright (c) 2020 Kwame Yamgane. All rights reserved.
##
## Redistribution and use in source and binary forms, with or
## without modification, are permitted provided that the following
## conditions are met:
##
## 1. Redistributions of source code must retain the above copyright
##    notice, this list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above
##    copyright notice, this list of conditions and the following
##    disclaimer in the documentation and/or other materials
##    provided with the distribution.
##
## 3. All advertising materials mentioning features or use of this
##    software must display the following acknowledgement: This
##    product includes software developed by the organization.
##
## 4. Neither the name of the copyright holder nor the names of its
##    contributors may be used to endorse or promote products derived
##    from this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY COPYRIGHT HOLDER "AS IS" AND ANY
## EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
## THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT
## HOLDER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
## TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
## OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
## THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
## TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
## OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
## OF SUCH DAMAGE.

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
    def_action = for action <- action_list do
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
    def_list = quote do
      @doc """
      #{unquote(crud)}.list for bill.com api
      ## Parameters: 
      conn - a connection strucure (see Billcom.login/0)
      data - data object to send for the object
      ## return:
      - success: {:ok, val}
      - fail: {:error, val}
      """		 
      def list(conn, data) do
       	conn = Billcom.update_map(conn, :conn_url, conn.api_url <> "/List/" <> unquote(crud) <> ".json")
       	Billcom.create_body(conn, data)
       	|> Billcom.execute(conn)
      end
    end
    
    Module.create(String.to_atom("Elixir.Billcom.#{crud}"), def_action ++ [def_list], Macro.Env.location(__ENV__))
end
