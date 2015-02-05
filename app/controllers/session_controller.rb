class SessionController < ApplicationController
  skip_before_action :authorize #, only: [:create]
  def new
    @user =  User.new
    render :layout => 'sign_in'
  end

  def create
    user = User.find_by_account(params[:account])
    if user and user.authenticate(params[:password])
      session[:account]=  user.account
      redirect_to users_url
      else
        redirect_to sign_in_path, alert: "Invalid user/password combination"
    end

  end

  def destroy
    session[:account] = nil
    redirect_to sign_in_url
  end
end
