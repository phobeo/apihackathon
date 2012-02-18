before do
  @twitter = Social::Twitter.new(settings.twitter_config, session)
  tw_screen_name = session[:tw_screen_name]
  unless tw_screen_name.nil?
    session[:user_id] = tw_screen_name
    @user = User.new(tw_screen_name)
  else
    @user = nil
  end  
end