class TariffsController < ApplicationController

  before_action :set_tariffs
  before_action :set_tariff, except: [:new]

  def index
    @tariffs = @tariffs.order(:id).page(params[:page]).decorate
  end

  def new
    @tariff = @tariffs.new
  end

  def create
    @tariff = @tariffs.new(tariff_params)
    if @tariff.save
      redirect_to @tariff, notice: 'Tariff was successfully created.'
    else
      render :new
    end
  end

  def update
    if @tariff.update(tariff_params)
      redirect_to @tariff, notice: 'Tariff was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @tariff.destroy
    redirect_to tariffs_url, notice: 'Tariff was successfully destroyed.'
  end

  private

  def set_tariffs
    @tariffs = Tariff.all
  end

  def set_tariff
    return if params[:id].nil?
    @tariff = @tariffs.find(params[:id]).decorate
  end

  def tariff_params
    params.require(:tariff).permit(:default, :name, :core, :memory, :storage, :address)
  end

end
