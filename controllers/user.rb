require 'lib/twitter'

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
    @game.create_player(session[:tw_screen_name])
    redirect '/'
    # TODO: add user to the pool
  else
    session.clear
    status 403
    'Twitter authentication failed. If the problem persists, delete your cookies and try again.'      
  end
end
