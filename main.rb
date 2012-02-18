$LOAD_PATH << '.'

require 'sinatra'
require 'sinatra/base'
require 'bundler/setup'

require 'config'
require 'lib/notifier'

require 'helpers/misc'
require 'helpers/game'
require 'user'
require 'models/models'
require 'models/pearson'
require 'controllers/game'

get '/' do
  if session[:user_id]
    @user_score = @game.get_player_score(@user)
    p = Pearson.new
    @result = @game.create_game('111', p.word, p.desc)
    @game.add_player_to_game(@user, '111')
    if @game.get_players_for_game('111').size > 1
      @channel = GameChannel.new('111')
      @channel.publish_start_game
      redirect '/game'
    end
    erb :index
  else
    erb :login
  end
end

get '/game' do
  erb :game, :layout => false
end

get '/imgrender/*' do |level|
  if level.to_i == 7
    erb :endimg, :layout => false
  else
    @firelevel = 1.to_f/level.to_i.to_f
    erb :gatico, :layout => false
  end
end