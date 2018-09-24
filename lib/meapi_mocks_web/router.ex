defmodule MeapiMocksWeb.Router do
  use MeapiMocksWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MeapiMocksWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/", MeapiMocksWeb do
    pipe_through :api
    post "/mercury-1.0/api/mercury/v1/delivery", PageController, :inject
    get "/integration/ws/meapi/v1/scanBarCode", PageController, :search_upc
    post "/integration/ws/meapi/v1/notifyStatusChange", PageController, :notifiy_status_change
    get "/integration/ws/meapi/v1/order/:order_id/status", PageController, :order_status
    get "/api/mercury/v1/delivery/:order_id/delivery_position", PageController, :order_position
    post "/integration/ws/meapi/v1/finalOrder", PageController, :final_order
    post "/mercury-1.0/api/mercury/v1/delivery", PageController, :inject_order
  end
end
