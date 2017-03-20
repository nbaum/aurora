class ServerEventsController < ApplicationController

  before_action :set_server_events
  before_action :set_server_event, except: [:new, :index]

  def index
    @server_events = @server_events.order(:id).page(params[:page]).decorate
  end

  def new
    @server_event = @server_events.new
  end

  def create
    @server_event = @server_events.new(server_event_params)
    if @server_event.save
      redirect_to @server_event, notice: 'Server event was successfully created.'
    else
      render :new
    end
  end

  def update
    if @server_event.update(server_event_params)
      redirect_to @server_event, notice: 'Server event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @server_event.destroy
    redirect_to server_events_url, notice: 'Server event was successfully destroyed.'
  end

  private

  def set_server_events
    return if params[:server_id].nil?
    @server = Server.find(params[:server_id])
    @server_events = @server.events
  end

  def set_server_event
    return if params[:id].nil?
    @server_event = @server_events.find(params[:id]).decorate
  end

  def server_event_params
    params.require(:server_event).permit(:server_id, :name, :data)
  end

end
