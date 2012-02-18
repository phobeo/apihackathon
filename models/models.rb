require "redis"
require "uri"

class Game
  # modelled as HASH
  # game:id, word, clue, is_clue_published
  K_GAMES = 'games:'

  K_GAMEMEMBERS = 'game_members:'

  # modelled as HASH
  # playergame:id, game:id, life, guesses, word_status
  K_GAMEPLAYERS = 'game_players:'
  # modelled as ZSET
  # twitter_id [score]
  K_PLAYERS = 'players'

  DEFAULT_LIFE=6

  def initialize(redis_uri)
    uri = URI.parse(redis_uri)
    @redis = Redis.new(:host => uri.host,
    :port => uri.port,
    :password => uri.password)
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

  def create_player(twitter_id)
    if @redis.zscore(K_PLAYERS, twitter_id).nil?
      @redis.zadd(K_PLAYERS, 0, twitter_id)
    end
  end

  def add_player_to_game(twitter_id, game_id)
    word = get_game_word(game_id)
    @redis.hmset("#{K_GAMEPLAYERS}#{twitter_id}", 'game_id', game_id, "life", DEFAULT_LIFE, "guesses", 0, "word_status", '*' * word.size)
    @redis.sadd("#{K_GAMEMEMBERS}#{game_id}", twitter_id)    
  end

  def is_game_available(game_id)
    @redis.hget("#{K_GAMES}#{game_id}") == nil
  end

  def create_game(game_id, word, clue)
    @redis.hmset("#{K_GAMES}#{game_id}", "word", word, "clue", clue, "is_clue_published", "false");
  end

  def get_game_clue(game_id)
    @redis.hget("#{K_GAMES}#{game_id}", 'clue')
  end

  def get_game_word(game_id)
    @redis.hget("#{K_GAMES}#{game_id}", 'word')
  end

  def get_players_for_game(game_id)
    @redis.smembers("#{K_GAMEPLAYERS}#{game_id}")
  end

  def guess_by_player(twitter_id, game_id, letter)
    status = get_player_status(twitter_id)
    word = get_game_word(game_id)

    unlocked_word = status['word_status']
    right_count = 0

    word.each_with_index do |item, index|
      if letter == item
        unlocked_word[index] = item
        right_count += 1
      end
    end

    if right_count == 0
      user_count_fail(twitter_id)
    end    

    update_player_word(twitter_id, unlocked_word)    
    return right_count
  end

  def update_player_word(twitter_id, new_word)
    @redis.hset("#{K_GAMEPLAYERS}#{twitter_id}", "word_status", new_word)
  end

  def get_player_status(twitter_id)
    @redis.hgetall("#{K_GAMEPLAYERS}#{twitter_id}")
  end

  def solve_by_player(twitter_id, game_id, solution)
    correct_word = get_game_word(game_id)
    if solution == correct_word
      return true
    else
      user_count_fail(twitter_id)
      return false
    end
  end

  def user_count_fail(twitter_id)
    status = get_player_status(twitter_id)
    life = status['life']

    @redis.hset("#{K_GAMEPLAYERS}#{twitter_id}", "life", life - 1)    
  end

end