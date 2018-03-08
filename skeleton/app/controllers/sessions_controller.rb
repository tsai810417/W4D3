class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    user.reset_session_token! if user
    session[:session_id] = user.session_token
    # debugger
    redirect_to cats_url
  end

  def destroy
    user = current_user
    user.reset_session_token! if user
    session[:session_id] = nil
  end


end
