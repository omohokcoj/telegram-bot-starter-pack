defmodule TelegramBot.HelloWorldResponder do
  use TelegramBot.Responder

  on_message ["/start", "/s"] do
    send_message "Welcome!"
  end

  on_message ~r/hello!*/ui do
    send_message "Hi #{message.from.first_name}!"
  end

  on_message ~r/(?<question>.*)\?/ui do
    send_message "You just asked me: #{captures.question}"
  end

  on_message ~r/.*/ui do
    send_message "I don't know what to say"
  end
end
