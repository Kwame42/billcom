defmodule BillcomTest do
  use ExUnit.Case
  doctest Billcom

  test "Login!" do
    assert Map.has_key?(Billcom.login!(), :session_id)
  end

  test "List organisation" do
    assert Billcom.login!()
    |> Billcom.list_orgs()
    |> elem(1)
    |> Map.fetch!("response_data")
    |> List.first()
    |> Map.has_key?("orgId")
  end

  test "This test only one function to set strucutre value: Billcom.set_user_name/2" do
    conn = Billcom.login!()
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
    conn = Billcom.login!()
    result = Billcom.Customer.create(conn, customer)
    id = Billcom.get_val(result, "id")
    assert elem(result, 0) == :ok and id
    customer = %{obj: Map.put(customer.obj, :id, id)}
    result = Billcom.Customer.read(conn, %{id: id})
    assert elem(result, 0) == :ok    
    customer = %{obj: Map.put(customer.obj, :shortName, "mouai")}
    result = Billcom.Customer.update(conn, customer)
    assert elem(result, 0) == :ok and Billcom.get_val(result, "shortName") ==  "mouai"
    result = Billcom.Customer.delete(conn, %{id: id})
    assert Billcom.get_val(result, "isActive") == "2"
    result = Billcom.Customer.undelete(conn, %{id: id})
    assert Billcom.get_val(result, "isActive") == "1"
  end

  test "Logout" do
    conn = Billcom.login!()
    assert Billcom.logout(conn) |> elem(0) == :ok
  end
end
