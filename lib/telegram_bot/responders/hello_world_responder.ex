defmodule TelegramBot.HelloWorldResponder do
  use TelegramBot.Responder

  on "/start" do
    send_resp(message, "Welcome!")
  end

  on ~r/hello!*/ui do
    send_resp(message, "Hi #{message.user.first_name}!")
  end

  on ~r/(?<question>.*)\?/ui do
    send_resp(message, "You just asked me: #{message.captures.question}")
  end
end
