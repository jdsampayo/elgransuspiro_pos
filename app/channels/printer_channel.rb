class PrinterChannel < ApplicationCable::Channel
  def subscribed
    stream_from "printer_channel:#{uid}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def print(data)
    puts "Received print "
    message = data['message']
    ActionCable.server.broadcast("printer_channel", message: message)
  end
end
