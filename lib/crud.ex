crud_list =  [Billcom.Customer, Billcom.CustomerContact]
action_list = ["create", "read", "update", "delete", "undelete"]

for crud <- crud_list do
    def_list = for action <- action_list do
      quote do
	def unquote(:"#{action}")(connection, data) do
	  json_file = String.slice("#{unquote(crud)}", String.length("Elixir.") + String.length("Billcom."), String.length("#{unquote(crud)}")) <> ".json"
	  conn = Billcom.update_map(connection, :conn_url, connection.api_url <> "/" <> String.capitalize(unquote(action)) <> "/" <> json_file)
	  
	  Billcom.create_body(conn, data)
	  |> Billcom.execute(conn)
	  |> Map.fetch!("response_data")
	end
      end
    end
    
    Module.create(crud, def_list, Macro.Env.location(__ENV__))
end
