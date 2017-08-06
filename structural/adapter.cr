# The adapter design pattern is used to provide a link between two
# incompatible types by wrapping the "adaptee" with a class that supports
# the interface required by the client.

class GameServer
  def add_client(client)
    client.connect "Mortal Kombat Game Server"
  end
end

class DesktopClient
  def open_connection(server)
    puts "New TCP connection to '#{server}'"
  end
end

class WebClient
  def initialize(@server : String)
  end

  def websocket_connection
    puts "New Websocket connection to '#{@server}'"
  end
end

abstract class Client
  abstract def connect(server)
end

class DesktopClientAdapter < Client
  def initialize
    @client = DesktopClient.new
  end

  def connect(server)
    @client.open_connection(server)
  end
end

class WebClientAdapter < Client
  def connect(server)
    WebClient.new(server).websocket_connection
  end
end

server = GameServer.new
server.add_client DesktopClientAdapter.new
server.add_client WebClientAdapter.new

# New TCP connection to 'Mortal Kombat Game Server'
# New Websocket connection to 'Mortal Kombat Game Server'
