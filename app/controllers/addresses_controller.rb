class AddressesController < ApplicationController

  before_action :set_addresses
  before_action :set_address, except: [:new]

  def index
    @addresses = @addresses.page(params[:page]).decorate
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
    redirect_to addresses_url, notice: 'Address was successfully destroyed.'
  end

  private

  def set_addresses
    @addresses = Address.all
  end

  def set_address
    return if params[:id].nil?
    @address = @addresses.find(params[:id]).decorate
  end

  def address_params
    params.require(:address).permit(:ip, :account_id, :server_id, :network_id)
  end

end
