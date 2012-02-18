require 'json'

post '/game/:game_id/clue' do
  channel = GameChannel.new('111')
  channel.publish_clue(@game.get_game_clue(@user, '111'))
  
  status = @game.get_player_status(@user, '111')  
  return JSON.dump(status)
end

post '/game/:game_id/guess/:letter' do
  channel = GameChannel.new('111')
  right_count = @game.guess_by_player(@user, '111', @letter)
  if right_count > 0
    channel.publish_guess_right(@user, right_count)
  else
    channel.publish_fail(@user)
  end
  
  status = @game.get_player_status(@user, '111')  
  return JSON.dump(status)
end

post '/game/:game_id/solve/' do
  channel = GameChannel.new('111')
  solution = params[:post]['solution']
  
  if @game.solve_by_player(@user, '111', solution)
    channel.publish_win(@user, solution)
  else
    channel.publish_fail(@user)
  end
  
  status = @game.get_player_status(@user, '111')  
  return JSON.dump(status)
end

post '/game/:game_id/chat' do
  message = params[:post]['message']
  channel.publish_message(@user, message)
end