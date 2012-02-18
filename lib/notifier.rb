require 'pusher'
require 'json'

class GameChannel
  UPDATE_EVENT = 'update'
    
  def initialize(game_id)
    @channel_id = "game:#{game_id}"
  end
  
  def publish_clue(username, message)
    publish({:type => 'clue', 
             :message => message,
             :requestedBy => username})
  end
  
  def publish_message(username, message)
    publish({:type => 'msg',
             :msg => message,
             :username => username})
  end
  
  def publish_guess_right(username, char_count)
    publish({:type => 'guess', 
             :guess => username,
             :letters => char_count})
  end
  
  def publish_guess_fail(username)
    publish({:type => 'fail',
             :fail => username})
  end
  
  protected
  
  def publish(data)
    Pusher[@channel_id].trigger(UPDATE_EVENT, json.dumps(data))
  end

end



