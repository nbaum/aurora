class ZonesController < ApplicationController

  before_action :set_zones
  before_action :set_zone, except: [:new]

  def index
    @zones = @zones.order(:id).page(params[:page]).decorate
  end

  def new
    @zone = @zones.new
  end

  def create
    @zone = @zones.new(zone_params)
    if @zone.save
      redirect_to @zone, notice: 'Zone was successfully created.'
    else
      render :new
    end
  end

  def update
    if @zone.update(zone_params)
      redirect_to @zone, notice: 'Zone was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @zone.destroy
    redirect_to zones_url, notice: 'Zone was successfully destroyed.'
  end

  private

  def set_zones
    @zones = Zone.all
  end

  def set_zone
    return if params[:id].nil?
    @zone = @zones.find(params[:id]).decorate
  end

  def zone_params
    params.require(:zone).permit(:name, :dns1, :dns2)
  end

end
