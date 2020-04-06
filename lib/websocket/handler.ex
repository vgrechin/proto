defmodule Proto.WebSocket.Handler do
  @behaviour :cowboy_websocket

  def init( req, state ) do
    {:cowboy_websocket, req, state}
  end

  def websocket_init( _state ) do
    send_messages( self() )
    {:ok, %{}}
  end

  defp send_messages( pid ) do
    Kernel.spawn( fn() ->
      Enum.each( 1..10, fn( index ) ->
        :timer.sleep( :timer.seconds( 1 ) )
        send( pid, {:message, "generated message #{index}"} )
      end )
    end )
  end

  def websocket_info( {:message, message }, state ) do
    IO.inspect( message, label: "Info" )
    {:reply, {:text, message}, state}
  end

  def websocket_info( _info, state ) do
    {:ok, state}
  end

  def websocket_handle( {:text, message}, state ) do
    IO.inspect( message, label: "Handle" )
    ticker = Proto.ticker
    IO.inspect( ticker, label: "Ticker")
    {:reply, {:text, ticker}, state}
  end

  def websocket_handle( {:json, json}, state ) do
    {:reply, {:text, json}, state}
  end

  def websocket_handle( _message, state ) do
    {:ok, state}
  end

  def websocket_terminate( _reason, _req, _state ) do
    :ok
  end
end
