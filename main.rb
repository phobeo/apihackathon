require 'sinatra'
require 'sinatra/base'
require 'bundler/setup'

class Main < Sinatra::Base
  get '/' do
    erb :index
  end
  
  get '/game' do
    erb :game, :layout => false
  end
end