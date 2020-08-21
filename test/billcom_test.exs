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
  
  test "Logout" do
    conn = Billcom.login()
    assert Billcom.logout(conn) == :ok
  end

  
end
