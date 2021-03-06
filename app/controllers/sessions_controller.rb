# Copyright (c) 2016 Nathan Baum

class SessionsController < ApplicationController

  skip_before_filter :check_authentication, only: [:new, :create]

  before_action :set_sessions
  before_action :set_session, except: [:new]

  def index
    @sessions = @sessions.order(:id).page(params[:page]).decorate
  end

  def new
    @session = @sessions.new
  end

  def create
    @session = @sessions.new(session_params)
    if @session.save
      session[:sid] = @session.id
      redirect_to params[:path] || :root, notice: "Welcome to Aurora."
    else
      render :new
    end
  end

  def terminate
    @session.update! updated_at: Time.now
    redirect_to :root
  end

  private

  def set_sessions
    @sessions = Session.all
  end

  def set_session
    return if params[:id].nil?
    @session = @sessions.find(params[:id]).decorate
  end

  def session_params
    if ENV["GAPING_SECURITY_HOLE"]
      params.require(:session).permit(:email, :password, :user_id)
    else
      params.require(:session).permit(:email, :password)
    end
  end

end
