# Billcom

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `billcom` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:billcom, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/billcom](https://hexdocs.pm/billcom).

## Configuration:

Create a config file:

```elixir
config :billcom, :api,
  %{
    devKey: "myDevKey",
    orgId: "myOrgId",
    password: "myPassword",
    userName: "myUsername"
  }

```

## Usage

```elixir
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
customer = %{obj: Map.put(customer.obj, :id, id)}
result = Billcom.Customer.read(conn, %{id: id})
customer = %{obj: Map.put(customer.obj, :shortName, "mouai")}
result = Billcom.Customer.update(conn, customer)
result = Billcom.Customer.delete(conn, %{id: id})
result = Billcom.Customer.undelete(conn, %{id: id})
Billcom.logout()
```
