defmodule Proto do
  use Application

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
end
