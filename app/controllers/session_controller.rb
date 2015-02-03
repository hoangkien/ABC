class SessionController < ApplicationController
  def new
    @user =  User.new
    render :layout => 'sign_in'
  end

  def create
  end

  def destroy
  end
end
