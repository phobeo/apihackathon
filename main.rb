$LOAD_PATH << '.'

require 'sinatra'
require 'sinatra/base'
require 'bundler/setup'

require 'config'
require 'notifier'

require 'helpers/misc'
require 'user'

get '/' do
  erb :index
end