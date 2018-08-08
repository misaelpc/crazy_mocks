defmodule MeapiMocksWeb.PageController do
  use MeapiMocksWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def inject(conn, _params) do
    conn
      |> put_status(200)
      |> json(%{status: 1,
                custom: "5b02ecf54f833004be299f84",
                message: "ACTION_COMPLETED",
                contact: nil,
                paymentMethods: nil})
  end

  def search_upc(conn, %{"upc" => "fourloko"}) do
    conn
      |> put_status(400)
      |> json(%{error: "UPC not found"})
  end

  def search_upc(conn, %{"upc" => upc}) do
    conn
      |> put_status(200)
      |> json(%{productId: 50003481,
                url: "http://192.168.10.1/super/images/Products/img_small/0075810400523s.jpg",
                unit: "KG",
                shortName: "short name",
                longName: "XBOX One",
                price: 9.9,
                pesable: true,
                restricted: true,
                aisle: "Jugueteria"})
  end

  def notifiy_status_change(conn, %{"orderID" => order_id,
                                    "oldStatus" => old_status,
                                    "newStatus" => new_status,
                                    "cancelReasonId" => reason}) do
    conn
      |> put_status(200)
      |> json(%{orderID: order_id, status: new_status})
  end

  def notifiy_status_change(conn, %{"orderID" => order_id,
                                    "newStatus" => new_status,
                                    "cancelReasonId" => reason}) do
    conn
      |> put_status(200)
      |> json(%{orderID: order_id, status: new_status})
  end

  def order_status(conn, %{"order_id" => order_id}) do
    conn
      |> put_status(200)
      |> json(%{"orderID" => 12312, "status" => "READY_FOR_PICKUP"})
  end

  def order_position(conn, %{"order_id" => order_id}) do
    conn
      |> put_status(200)
      |> json(%{"data" => %{"timestamp" => "2018-06-11T15:20:49.000Z",
                            "longitude" => 99.229222,
                            "latitude" => -19.928372,
                            "customkey" => order_id}})
  end

  def final_order(conn, _params) do
    conn
      |> put_status(200)
      |> json(order_response)
  end

  def order_response do
    %{
      "comment" => "Prueba con blancos usuario invitado",
      "orders" => [
        %{
          "address" => %{
            "address" => "LAZARO CARDENAS , , DOS VISTAS, Veracruz, Mexico",
            "address_reference" => "",
            "between_street1" => "LAZARO CARDENAS ",
            "between_street2" => "LAZARO CARDENAS ",
            "city" => "DOS VISTAS",
            "country" => "Mexico",
            "external_number" => "",
            "id" => 0,
            "internal_number" => "",
            "latitude" => 19.5119394,
            "longitude" => -96.8719591,
            "neighborhood" => "",
            "postal_code" => "91194",
            "state" => "Veracruz",
            "street" => "LAZARO CARDENAS "
          },
          "comment" => "Prueba con blancos usuario invitado",
          "consumer" => %{
            "id" => "75024dca-1aa1-4479-aae9-5b56194137fe",
            "user" => %{
              "email" => "",
              "person" => %{
                "birthdate" => "",
                "contact" => %{"ext" => "0", "mean" => 1, "value" => "2288421100"},
                "gender" => "-1",
                "lastname" => "",
                "name" => "",
                "secondname" => ""
              }
            }
          },
          "contact_preferences" => "",
          "customkey" => "9999901814",
          "delivery_type" => "ENVIO",
          "original_order_request" => %{
            "delivery_instructions" => "",
            "order_date" => "2018-07-06T07:51:49.596Z",
            "order_request_items" => [
              %{
                "comments" => "",
                "discount" => 0.0,
                "item_id" => "81356800293",
                "product" => %{
                  "aisle" => "",
                  "image_url" => "https://admin-stage.chedraui.com.mx/medias/81356800293-00-CH300Wx300H?context=bWFzdGVyfHJvb3R8NzQzMzd8aW1hZ2UvanBlZ3xoMGIvaDFkLzg4MjMwOTU2NTY0NzguanBnfDQ0ZjMwMDRiYWFiMTI4M2Y0ZmQ4OWQzNTM1NTliN2UxYTQ5NDViNDgzZTNmOTQwYjAzODhlMGNiNWNhYmZmMzU",
                  "long_name" => "Cereal Pereg de Quinoa Sabor Fresa 100 gramos",
                  "pesable" => false,
                  "price" => 120.0,
                  "product_id" => "000000000003354591",
                  "restricted" => true,
                  "short_name" => "Cereal De Quinoa Fresa Pereg",
                  "thumbnail_url" => "https://admin-stage.chedraui.com.mx/medias/81356800293-00-CH96Wx96H?context=bWFzdGVyfHJvb3R8MzMyNDF8aW1hZ2UvanBlZ3xoMTIvaGIxLzg4MjMwOTU3ODc1NTAuanBnfDQ1MWIzNWZlYWQ2MTIwZGZiMzYyODA2YzJkZWU5ZGU0NmJlNjNiNWNjMDY3NWQ1NDQ2NzMzNmNiNGY1NDU3ZDA",
                  "unit" => "PCE",
                  "upc" => "81356800293"
                },
                "quantity" => 2.0,
                "total_price" => 240.0,
                "unit_price" => 120.0
              }
            ],
            "order_shipment_cost" => 20.0,
            "order_total_cost" => 240.0
          },
          "payment" => %{
            "pay_on_delivery_type" => "",
            "payment_mode" => "Tarjeta ",
            "payment_status" => ""
          },
          "phone1" => "2288421100",
          "phone2" => "2288421100",
          "recipient1" => "ABRIL",
          "recipient2" => "DANIA",
          "request_id" => "02488937",
          "status" => "READY",
          "store_id" => "0059",
          "time_slot" => %{
            "id_store" => "0059",
            "service_type" => 1,
            "time_from" => "2018-07-06T10:00:00.000Z",
            "time_to" => "2018-07-06T12:00:00.000Z"
          }
        }
      ],
      "request_date" => "2018-07-06T07:53:44.412Z",
      "request_id" => "0248893",
      "request_shipment_cost" => 20.0,
      "request_total_cost" => 260.0,
      "request_total_discount" => 0.0,
      "request_total_taxes" => 17.78,
      "status" => "FRAUD_CHECKED"
    }
  end
end
