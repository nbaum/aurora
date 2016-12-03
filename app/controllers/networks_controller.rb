# Copyright (c) 2016 Nathan Baum

class NetworksController < ApplicationController

  before_action :set_networks
  before_action :set_network, except: [:new]

  def index
    @networks = @networks.order(:id).page(params[:page]).decorate
  end

  def new
    @network = @networks.new
  end

  def create
    @network = @networks.new(network_params)
    if @network.save
      redirect_to @network, notice: "Network was successfully created."
    else
      render :new
    end
  end

  def update
    if @network.update(network_params)
      redirect_to @network, notice: "Network was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @network.destroy
    redirect_to networks_url, notice: "Network was successfully destroyed."
  end

  private

  def set_networks
    @networks = Network.all
  end

  def set_network
    return if params[:id].nil?
    @network = @networks.find(params[:id]).decorate
  end

  def network_params
    params.require(:network).permit(:name, :bridge, :account_id, :bundle_id, :zone_id, :index)
  end

end
