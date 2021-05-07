require_relative 'loader'
require_relative 'reply_factory'

class Talking
  def self.send(req)
    Sender.for(req).send
  end
end

class Sender
  def self.for(req)
    case req.message.text
    when '/start'
      User.find_or_create_by(telegram_id: req.message.from.id)
      Response.new(req, Bot.instance.answer[:welcome])
    when '/pause'
      Response.new(req, Bot.instance.answer[:pause])
    when '/stop'
      Response.new(req, Bot.instance.answer[:bye])
    when /[1-6]/
      RegisterResponse.new(req)
    when '🙂'
      FeedbackResponse.new(req)
    else
      Response.new(req, Bot.instance.answer[:spam])
    end
  end
end
