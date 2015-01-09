class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_account

  helper_method :current_user

  def current_account
    current_user.account
  end

  def current_user
    User.first
  end

  before_action do
    @title = []
  end

end
