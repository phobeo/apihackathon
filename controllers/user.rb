require 'sinatra/base'
require 'lib/twitter'
  
get '/me' do
  'Yepa'
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/twitter/connect' do
  twitter = Social::Twitter.new(settings.twitter_config, session)  
  redirect twitter.get_auth_url(session)
end

get '/twitter/callback' do
  twitter = Social::Twitter.new(settings.twitter_config, session)
  if twitter.authenticate!(session)
    redirect '/'
  else
    session.clear
    status 403
    'Twitter authentication failed. If the problem persists, delete your cookies and try again.'      
  end
end
