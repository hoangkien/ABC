class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize

  protected
  def authorize
    unless User.find_by_account(session[:account])
       redirect_to sign_in_path, alert: "please sign in first!"
    end
  end

end
