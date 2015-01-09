class HostsController < ApplicationController

  before_action :set_hosts
  before_action :set_host, except: [:new]

  def index
    @hosts = @hosts.page(params[:page]).decorate
  end

  def new
    @host = @hosts.new
  end

  def create
    @host = @hosts.new(host_params)
    if @host.save
      redirect_to @host, notice: 'Host was successfully created.'
    else
      render :new
    end
  end

  def update
    if @host.update(host_params)
      redirect_to @host, notice: 'Host was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @host.destroy
    redirect_to hosts_url, notice: 'Host was successfully destroyed.'
  end

  private

  def set_hosts
    @hosts = Host.all
  end

  def set_host
    return if params[:id].nil?
    @host = @hosts.find(params[:id]).decorate
  end

  def host_params
    params.require(:host).permit(:name, :cores, :memory, :storage, :url, :address, :compute, :storage, :zone_id)
  end

end
