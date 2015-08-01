# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class ServersVolumesController < ApplicationController

  before_action :set_servers_volumes
  before_action :set_servers_volume, except: [:new]

  def index
    @servers_volumes = @servers_volumes.order(:id).page(params[:page]).decorate
  end

  def new
    @servers_volume = @servers_volumes.new
  end

  def create
    @servers_volume = @servers_volumes.new(servers_volume_params)
    if @servers_volume.save
      redirect_to @servers_volume, notice: "Servers volume was successfully created."
    else
      render :new
    end
  end

  def update
    if @servers_volume.update(servers_volume_params)
      redirect_to @servers_volume, notice: "Servers volume was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @servers_volume.destroy
    redirect_to servers_volumes_url, notice: "Servers volume was successfully destroyed."
  end

  private

  def set_servers_volumes
    @servers_volumes = ServersVolume.all
  end

  def set_servers_volume
    return if params[:id].nil?
    @servers_volume = @servers_volumes.find(params[:id]).decorate
  end

  def servers_volume_params
    params.require(:servers_volume).permit(:attachment, :server_id, :volume_id)
  end

end
