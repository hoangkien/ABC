class SessionController < ApplicationController
  skip_before_action :authorize #, only: [:create]
  def new
    @user =  User.new
    render :layout => 'layouts/sign_in'
  end

  def create
    user = User.find_by_account(params[:account])
    if user and user.authenticate(params[:password])

      # session[:user]=  {:id => user.id, :account => user.account,:group => user.group}
      session[:account]= user.account
      session[:group] =  user.group
      redirect_to users_url
    else
        redirect_to sign_in_path, alert: "Invalid user/password combination"
    end

  end

  def destroy
    session[:account] = nil
    session[:group] = nil
    redirect_to sign_in_url
  end
end
