class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      # sign_in user, store: false
      flash[:notice] = "Logged in successfully."
      redirect_to_target_or_default("/")
    else
      flash.now[:error] = "Invalid login or password."
      render :action => "new"
    end
  end

  def destroy
    # sign_out current_user
    session[:user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end
end
