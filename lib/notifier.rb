require 'pusher'
require 'json'

class GameChannel
  EVENTS = {
    :clue => 'clue',
    :message => 'msg',
    :guess => 'guess',
    :fail => 
  }
  
  def initialize(game_id)
    @channel_id = "game:#{game_id}"
  end
  
  def publish_clue(username, message)
    publish(EVENTS[:clue], json.dumps(:type => 'clue', 
                                      :message => message,
                                      :requestedBy => username))
  end
  
  def publish_message(username, message)
    publish(EVENTS[:message], json.dumps(:type => 'msg',
                                         :msg => message,
                                         :username => username))
  end
  
  def publish_guess_right(username, char_count)
    publish(EVENTS[:guess], json.dumps(:type => 'guess', 
                                       :guess => username,
                                       :letters => char_count))
  end
  
  def publish_guess_fail(username)
    publish(EVENTS[:fail], json.dumps(:type => 'fail',
                                      :fail => username))
  end
  
  protected
  
  def publish(data)
    Pusher[@channel_id].trigger()
  end

end



