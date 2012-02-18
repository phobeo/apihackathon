require 'pusher'

configure do
  set(:twitter_config, {
    :key => ENV['TWITTER_KEY'] || 'key',
    :secret => ENV['TWITTER_SECRET'] || 'secret',
    :callback_url => ENV['TWITTER_CALLBACK'] || 'http://0.0.0.0:9393/twitter/callback'
  })
  
  set :session_secret, ENV['SESSION_KEY'] || '1234'
end

Pusher.app_id = ENV['PUSHER_APP_ID'] || 'app'
Pusher.key = ENV['PUSHER_API_KEY'] || 'key'
Pusher.secret = ENV['PUSHER_SECRET_KEY'] || 'secret'

enable :sessions

