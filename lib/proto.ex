defmodule Proto do
  use Application
  use Protobuf, from: Path.expand( "../pub/ticker.proto", __DIR__ ), use_package_names: true

  def start( _type, _args ) do
    dispatch = :cowboy_router.compile( [{:_, [
      {"/proto", Proto.WebSocket.Handler, []},
      {"/ticker.proto", :cowboy_static, {:file, "pub/ticker.proto"}},
      {"/", :cowboy_static, {:file, "pub/index.html"}}
    ]}] )

    :cowboy.start_clear( :http,
      [{:port, 3040}],
      %{env: %{dispatch: dispatch}} )
  end

  def ticker do
    ticker = Proto.Basket.Ticker.new( %{symbol: "AAPL", price: 262.47, volume: 42_000} )
    Proto.Basket.Ticker.encode( ticker )
  end
end
