require "redis"

class Game
  # modelled as HASH
  # game:id, word, clue, is_clue_published
  K_GAMES = 'games'
  # modelled as HASH
  # playergame:id, game:id, life, guesses, word_status
  K_GAMEPLAYERS = 'game_players'
  # modelled as ZSET
  # twitter_id [score]
  K_PLAYERS = 'players'
  
  DEFAULT_LIFE=6
   
  def initialize
    @redis = Redis.new
  end
  
  def dump
    @redis.hgetall(K_GAMES)
    @redis.hgetall(K_GAMEPLAYERS)
    @redis.zrangebyscore(K_PLAYERS, '-inf', '+inf', :with_scores=>true)
  end
  
  def get_players_by_score
    @redis.zrangebyscore(K_PLAYERS, '-inf', '+inf', :with_scores=>true)
  end
  
  def get_player_score(twitter_id) 
    @redis.zscore(K_PLAYERS, twitter_id)
  end

  def create_player (twitter_id)
    @redis.zadd(K_PLAYERS, 0, twitter_id)
  end
  
  def add_player_to_game(twitter_id, game_id)
    @redis.hmset("#{K_GAMEPLAYERS}", twitter_id, "twitter:id", game_id, twitter_id, "life", DEFAULT_LIFE, "guesses", 0, "word_status", "[]");
  end
  
  def is_player_available(twitter_id) 
    @redis.hget("#{K_GAMEPLAYERS}", twitter_id) == nil
  end
  
  def is_game_available(game_id)
    @redis.hget("#{K_GAMES}", game_id) == nil
  end
  
  def create_game(game_id, word, clue)
    @redis.hmset("#{K_GAMES}", game_id, "game:id", "word", word, "clue", clue, "is_clue_published", "false");
  end
  
  def get_players_for_game(game_id)
    @redis.hmget("#{K_GAMEPLAYERS}", game_id)
  end
  
end
