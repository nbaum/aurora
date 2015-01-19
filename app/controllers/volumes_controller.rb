class VolumesController < ApplicationController

  before_action :set_volumes
  before_action :set_volume, except: [:new]

  def index
    @volumes = @volumes.page(params[:page]).decorate
  end

  def new
    @volume = @volumes.new.decorate
  end

  def create
    @volume = @volumes.new(volume_params)
    if @volume.save
      redirect_to @volume, notice: 'Volume was successfully created.'
    else
      render :new
    end
  end

  def update
    if @volume.update(volume_params)
      redirect_to @volume, notice: 'Volume was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @volume.destroy
    redirect_to volumes_url, notice: 'Volume was successfully destroyed.'
  end

  def attach
    raise params.inspect
  end

  def wipe
    @volume.wipe
    redirect_to @volume, notice: 'Volume was successfully wiped.'
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
