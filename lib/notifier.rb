require 'pusher'
require 'json'

class GameChannel
  UPDATE_EVENT = 'update'
  START_EVENT = 'start_game'
  WIN_EVENT = 'win_game'
    
  def initialize(game_id)
    @channel_id = "game"
  end
  
  def publish_start_game()
    publish(START_EVENT, {:type => 'start'})
  end
  
  def publish_clue(username, message)
    publish(UPDATE_EVENT, {:type => 'clue', 
             :message => message,
             :requestedBy => username})
  end
  
  def publish_message(username, message)
    publish(UPDATE_EVENT, {:type => 'msg',
             :msg => message,
             :username => username})
  end
  
  def publish_guess_right(username, char_count)
    publish(UPDATE_EVENT, {:type => 'guess', 
             :guess => username,
             :letters => char_count})
  end
  
  def publish_fail(username)
    publish(UPDATE_EVENT, {:type => 'fail',
             :fail => username})
  end
  
  def publish_solved(username, word)
    publish(WIN_EVENT, {:type => 'win', :username => username, :word => word})
  end
  
  protected
  
  def publish(event, data)
    Pusher[@channel_id].trigger(UPDATE_EVENT, JSON.dump(data))
  end

end
