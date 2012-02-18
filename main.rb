$LOAD_PATH << '.'

require 'sinatra'
require 'sinatra/base'
require 'bundler/setup'

require 'config'

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