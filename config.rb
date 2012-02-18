configure do
  set(:twitter_config, {
    :key => ENV['TWITTER_KEY'] || 'key',
    :secret => ENV['TWITTER_SECRET'] || 'secret',
    :callback_url => ENV['TWITTER_CALLBACK'] || 'http://0.0.0.0:9393/twitter/callback'
  })
  
  set :session_secret, ENV['SESSION_KEY'] || '1234'
end

enable :sessions

