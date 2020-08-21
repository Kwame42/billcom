defmodule BillcomTest do
  use ExUnit.Case
  doctest Billcom

  test "Login" do
    assert Map.has_key?(Billcom.login(), :session_id)
  end

  test "List organisation" do
    assert Billcom.login()
    |> Billcom.list_orgs()
    |> List.first()
    |> Map.has_key?("orgId")
  end

  test "This test only one function to set strucutre value: Billcom.set_user_name/2" do
    conn = Billcom.login()
    val = Billcom.get_user_name(conn)
    conn = Billcom.set_user_name(conn, "#{val} this is different")
    assert Billcom.get_user_name(conn) == "#{val} this is different"
  end

  test "login / Create / read / update / delete / undelete a customer / logout" do
    customer = %{obj:
		 %{
		   entity: "Customer",
		   isActive: "1",
		   name: "This is the customer name",
		   shortName: "Testing Customer",
		   parentCustomerId: "",
		   companyName: "Diamond Industrial Inc.",
		   contactFirstName: "Kwame",
		   contactLastName: "Yamgnane",
		   accNumber: "212",
		   billAddress1: "123 South North Street"
		 }
		}
    conn = Billcom.login()
    result = Billcom.Customer.create(conn, customer)
    assert result == {:ok, _}
    result = Billcom.Customer.read(conn, customer)
    assert Map.fetch!(result, "response_data") |> Map.has_key?("id")
    id = Map.fetch!(result, "response_data") |> Map.fetch!("id")
    Map.put(customer.obj, shortName: "mouai")
    Map.put(customer.obj, id: id)
    result = Billcom.Customer.update(conn, customer)
    
    assert result == {:ok, _}
    
    
  end

  
  test "Logout" do
    conn = Billcom.login()
    assert Billcom.logout(conn) == {:ok, _}
  end
end
