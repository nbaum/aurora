class AddressesNetworksController < ApplicationController

  before_action :set_addresses_networks
  before_action :set_addresses_network, except: [:new]

  def index
    @addresses_networks = @addresses_networks.page(params[:page]).decorate
  end

  def new
    @addresses_network = @addresses_networks.new
  end

  def create
    @addresses_network = @addresses_networks.new(addresses_network_params)
    if @addresses_network.save
      redirect_to @addresses_network, notice: 'Addresses network was successfully created.'
    else
      render :new
    end
  end

  def update
    if @addresses_network.update(addresses_network_params)
      redirect_to @addresses_network, notice: 'Addresses network was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @addresses_network.destroy
    redirect_to addresses_networks_url, notice: 'Addresses network was successfully destroyed.'
  end

  private

  def set_addresses_networks
    @addresses_networks = AddressesNetwork.all
  end

  def set_addresses_network
    return if params[:id].nil?
    @addresses_network = @addresses_networks.find(params[:id]).decorate
  end

  def addresses_network_params
    params.require(:addresses_network).permit(:attachment, :server_id, :network_id)
  end

end
