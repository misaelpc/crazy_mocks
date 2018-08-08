defmodule OrderRoutes do

  def format do
    routes_ids = routes_identifiers()
    complete_routes = order_stations(routes_ids, complete_routes())
    routes_map = index_routes(complete_routes)
    {:ok, agent} = Agent.start_link fn -> %{} end
    Enum.map_reduce(routes_ids, 0,fn (indentifier, acc) ->
      case indentifier do
        "origin" ->
          {"", acc + 1}
        "destination" ->
          {"", acc + 1}
        route_id ->
          %{"route_id" => route_id,
            "station" => station,
            "kind" => kind,
            "time" => time,
            "index" => station_index,
            "name" => name} = routes_map[route_id]
          station = station
            |> Map.put("kind", kind)
            |> Map.put("time", time)
            |> Map.put("station_index", station_index)
          case Agent.get(agent, &Map.get(&1, route_id)) do
            nil ->
              Agent.update(agent, &Map.put(&1, route_id, %{"index" => acc,
                                                           :id => route_id,
                                                           :name => name,
                                                           :stations => [station]}))
            val ->
              %{:stations => stations, :name => c_name} = val
              new_stations = stations ++ [station]
              val = %{val | :stations => new_stations, name: c_name <> "|" <>name}
              Agent.update(agent, &Map.put(&1, route_id, val))
          end
          {"", acc + 1}
      end
    end)
    results = Agent.get(agent, fn result -> result end)
    routes = Enum.map(results, fn {k, v} -> v end)
    ordered_routes = Enum.sort_by(routes, fn %{"index" => index} -> index end, &sort_routes/2)
    Enum.map(ordered_routes, fn routes ->
      %{:stations => stations} = routes
      sorted_stations = Enum.sort_by(stations, fn %{"station_index" => index} -> index end, &sort_routes/2)
      names = Enum.map(sorted_stations, fn(%{"name" => name}) -> name end)
      final_name = List.first(names) <> " - " <> List.last(names)
      %{routes | :stations => sorted_stations, :name => final_name}
    end)
  end

  def sort_routes(index1, index2) do
    index1 < index2
  end

  def index_routes(complete_routes) do
    {:ok, agent} = Agent.start_link fn -> %{} end
    Enum.each(complete_routes, fn(route) ->
      %{"id" => route_id, "name" => name, "stations" => stations} = route
      Enum.map_reduce(stations, 0,fn(station, acc) ->
        kind =
        cond do
          acc == 0 ->
            "departure"
          acc < (Enum.count(stations) - 1) ->
            "step"
          true ->
            "arrival"
        end
        %{"id" => id, "name" => name, "time" => time} = station
        {:ok, datetime} = DateTime.from_unix(station["time"])
        iso_string = DateTime.to_iso8601(datetime)
        Agent.update(agent, &Map.put(&1, id, %{"index" => acc,
                                               "time" => iso_string,
                                               "kind" => kind,
                                               "station" => station,
                                               "route_id" => route_id,
                                               "name" => name}))
        {"", acc + 1}
      end)
    end)
    Agent.get(agent, fn result -> result end)
  end

  def order_stations(routes_ids, complete_routes) do
    Enum.map(complete_routes, fn(route) ->
      %{"stations" => stations} = route
      sorted_stations = Enum.sort(stations, fn(%{"id" => idx}, %{"id" => idy}) -> sort_with_table(idx, idy, routes_ids) end)
      %{route | "stations" => sorted_stations}
    end)
  end

  def sort_with_table(idx, idy, routes_ids) do
    val1 = Enum.find_index(routes_ids, fn(x) -> x == idx end)
    val2 = Enum.find_index(routes_ids, fn(x) -> x == idy end)
    val1 < val2
  end

  def routes_identifiers do
    ["origin", "0d5eb885-32c3-44c6-8f6d-743f94bb13ea",
     "a604dbf9-4b25-4d04-aa72-a0ff5878c6bb", "089d0693-b3c9-48a4-84b0-e2bb922efa01",
     "0eaa133e-cf27-41b0-a77d-87a2ccc1da59", "destination"]
  end

  def complete_routes do
    [
      %{
        "id" => "cf0578b0-02cf-4b28-9e60-1de7da3f196f",
        "name" => "Santa Fe - Xochimilco",
        "stations" => [
          %{
            "address" => "Alfonso Nápoles Gándara 50, Santa Fe, Zedec Sta Fé, 01219 Ciudad de México, CDMX",
            "id" => "0eaa133e-cf27-41b0-a77d-87a2ccc1da59",
            "location" => %{"latitude" => 19.373584, "longitude" => -99.259947},
            "name" => "CitiBanamex",
            "time" => 1527549289
          }
        ]
      },
      %{
        "id" => "63202e63-b23c-438b-bb6e-7b8114a89b73",
        "name" => "P. Xochimilco - Santa Fe",
        "stations" => [
          %{
            "address" => "Av. Canal de Miramontes 3642, Narciso Mendoza, 14390 U. Hab. Narciso Mendoza Super 4 Coapa, CDMX, México",
            "id" => "0d5eb885-32c3-44c6-8f6d-743f94bb13ea",
            "location" => %{
              "latitude" => 19.290995379288262,
              "longitude" => -99.12567232048039
            },
            "name" => "Vaqueritos",
            "time" => 1527109200
          },
          %{
            "address" => "Antonio Dovali Jaime 212, Santa Fe, Zedec Sta Fé, 01219 Ciudad de México, CDMX, México",
            "id" => "089d0693-b3c9-48a4-84b0-e2bb922efa01",
            "location" => %{"latitude" => 19.367781, "longitude" => -99.260085},
            "name" => "Samara (Corporativo Lobby Torre A)",
            "time" => 1527111833
          },
          %{
            "address" => "Periferico Sur, Insurgentes Cuicuilco, 04500 Ciudad de México, CDMX, México",
            "id" => "a604dbf9-4b25-4d04-aa72-a0ff5878c6bb",
            "location" => %{
              "latitude" => 19.3024938112236,
              "longitude" => -99.19156448686407
            },
            "name" => "Perisur",
            "time" => 1527110358
          }
        ]
      }
    ]
  end

end