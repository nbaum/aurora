# Copyright (c) 2016 Nathan Baum

class VolumesController < ApplicationController

  before_action :set_volumes
  before_action :set_volume, except: [:new]

  def index
    @volumes = @volumes.order(:id).page(params[:page]).decorate
  end

  def new
    @volume = @volumes.new.decorate
  end

  def create
    @volume = @volumes.new(volume_params)
    if @volume.save
      @volume.update(volume_params)
      @volume.realize
      redirect_to @volume, notice: "Volume was successfully created."
    else
      render :new
    end
  end

  def update
    if @volume.update(volume_params)
      redirect_to @volume, notice: "Volume was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @volume.destroy
    redirect_to volumes_url, notice: "Volume was successfully destroyed."
  end

  def attach
    raise params.inspect
  end

  def wipe
    @volume.wipe
    redirect_to @volume, notice: "Volume was successfully wiped."
  end

  def upload!
    vu = VolumeUploader.new @volume
    @volume.update! size: params[:volume][:file].size.inspect
    vu.store! params[:volume][:file]
    redirect_to :back, notice: "Volume data uploaded."
  end

  private

  def set_volumes
    @volumes = Volume.order(id: :desc)
  end

  def set_volume
    return if params[:id].nil?
    @volume = @volumes.find(params[:id]).decorate
  end

  def volume_params
    params.require(:volume).permit(:name, :size, :ephemeral, :optical, :server_id, :base_id, :account_id, :bundle_id, :storage_pool_id, :published_at)
  end

end
