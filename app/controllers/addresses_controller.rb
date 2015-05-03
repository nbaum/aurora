class AddressesController < ApplicationController

  before_action :set_network
  before_action :set_subnet

  before_action :set_addresses
  before_action :set_address, except: [:new]

  def index
    @addresses = @addresses.order(:id).page(params[:page]).decorate
  end

  def new
    @address = @addresses.new
  end

  def create
    @address = @addresses.new(address_params)
    if @address.save
      redirect_to @address, notice: 'Address was successfully created.'
    else
      render :new
    end
  end

  def update
    if @address.update(address_params)
      redirect_to @address, notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @address.destroy
    redirect_to [@network, @subnet, :addresses], notice: 'Address was successfully destroyed.'
  end

  private

  def set_network
    return if params[:network_id].nil?
    @network = Network.find(params[:network_id]).decorate
  end

  def set_subnet
    return if params[:subnet_id].nil?
    @subnet = @network.subnets.find(params[:subnet_id]).decorate
  end

  def set_addresses
    @addresses = @subnet.addresses.all
  end

  def set_address
    return if params[:id].nil?
    @address = @addresses.find(params[:id])
    @address = @address.decorate unless request.method == 'POST'
  end

  def address_params
    params.require(:address).permit(:ip, :account_id, :server_id, :network_id)
  end

end
