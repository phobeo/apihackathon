$LOAD_PATH << '.'

require 'sinatra'
require 'sinatra/base'
require 'bundler/setup'

require 'config'
require 'lib/notifier'

require 'helpers/misc'
require 'user'

get '/' do
  if session[:user_id]
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