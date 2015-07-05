class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :check_authentication
  #before_filter :check_authorization

  helper_method :current_account
  helper_method :current_user
  helper_method :current_session

  layout :select_layout

  def select_layout
    if current_user
      "application"
    else
      "bare"
    end
  end

  def check_authentication
    return if current_user
    redirect_to new_session_path(path: request.path)
  end

  def current_account
    current_user.account || Account.first
  end

  def current_user
    current_session.try(:user)
  end

  def current_session
    if session[:sid]
      s = Session.find(session[:sid]) rescue nil
      session[:sid] = nil if !s or s.ended_at
      s
    end
  end

  before_action do
    @title = []
  end

end
