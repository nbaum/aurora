# Copyright (c) 2016 Nathan Baum

class SubnetsController < ApplicationController

  before_action :set_network
  before_action :set_subnets
  before_action :set_subnet, except: [:new]

  def index
    @subnets = @subnets.order(:id).page(params[:page]).decorate
  end

  def new
    @subnet = @subnets.new
  end

  def create
    @subnet = @subnets.new(subnet_params)
    if @subnet.save
      redirect_to [@network, @subnet], notice: "Subnet was successfully created."
    else
      render :new
    end
  end

  def update
    if @subnet.update(subnet_params)
      redirect_to [@network, @subnet], notice: "Subnet was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @subnet.destroy
    redirect_to [@network, :subnets], notice: "Subnet was successfully destroyed."
  end

  private

  def set_network
    return if params[:network_id].nil?
    @network = Network.find(params[:network_id]).decorate
  end

  def set_subnets
    @subnets = @network.subnets.all
  end

  def set_subnet
    return if params[:id].nil?
    @subnet = @subnets.find(params[:id]).decorate
  end

  def subnet_params
    params.require(:subnet).permit(:kind, :gateway, :prefix, :first, :last, :network_id)
  end

end
