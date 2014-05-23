class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    session[:user_uid] = user.uid
    session[:user_name] = user.name
    session[:user_email] = user.email
    redirect_to snippets_url, :notice => "Signed in!"
  end

  def destroy
    reset_session
    redirect_to snippets_url, :notice => "Signed out!"
  end

end