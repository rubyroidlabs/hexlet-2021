# frozen_string_literal: true

require 'sinatra/activerecord'
require_relative 'loader'
require_relative 'generator'
require_relative 'models/user'
require_relative 'models/learned_definition'
require_relative 'models/definition'
require 'pry'

class Response
  def initialize(req, msg = '')
    @telegram_id = req.message.from.id
    @msg = msg
  end

  def send
    Bot.instance.api.sendMessage(chat_id: @telegram_id, text: @msg)
  end
end

class FeedbackResponse < Response
  include Generator
  def initialize(req)
    super(req)
    @req = req
    @telegram_id = req.message.from.id
    @msg = Bot.instance.answer[:accepted]
  end

  def send
    return unless status_active?

    user = User.by_id(@telegram_id).first
    cur_word = LearnedDefinition.by_user_id(user.id).order(created_at: :desc).first
    return if answered?(user, cur_word)

    if new?(user.repeat_qty, cur_word.received_qty, cur_word.sent_qty)
      @msg = Bot.instance.answer[:new]
      super
      sleep 1
      send_new_word
      super
      return
    end
    cur_word.update(received_qty: cur_word.received_qty + 1)
    super
  end

  private

  def answered?(user, cur_word)
    cur_word.sent_qty == cur_word.received_qty && user.repeat_qty > cur_word.sent_qty
  end

  def status_active?
    user = User.by_id(@telegram_id).where(status: User.statuses[:active])
    !user.empty?
  end

  def new?(qty, sent_qty, received_qty)
    return true if qty == sent_qty && qty == received_qty

    false
  end

  def send_new_word
    generate_word
  end
end

class RegisterResponse < Response
  include Generator
  def initialize(req)
    super(req)
    @req = req
    @telegram_id = req.message.from.id
    @msg = Bot.instance.answer[:registered]
  end

  def send
    return unless status_registered?

    # accept the qty
    super
    sleep 1
    send_new_word
    # send the new word
    super
    # change the status at the end to avoid concurrent conflict with scheduler
    register
  end

  private

  def register
    qty = @req.message.text.to_i
    User.where(telegram_id: @telegram_id).update_all(['status = ?, repeat_qty = ?', User.statuses[:active], qty])
  end

  def send_new_word
    generate_word
  end

  def status_registered?
    user = User.by_id(@telegram_id).where(status: User.statuses[:registered])
    !user.empty?
  end
end
