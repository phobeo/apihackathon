$LOAD_PATH << '.'

require 'sinatra'
require 'sinatra/base'
require 'bundler/setup'

require 'config'
require 'lib/notifier'

require 'helpers/misc'
require 'user'

get '/' do
  erb :index
end

get '/game' do
  erb :game, :layout => false
end