class BundlesController < ApplicationController

  before_action :set_bundles
  before_action :set_bundle, except: [:new]

  def index
    @bundles = @bundles.order(:id).page(params[:page]).decorate
  end

  def new
    @bundle = @bundles.new
  end

  def create
    @bundle = @bundles.new(bundle_params)
    if @bundle.save
      redirect_to @bundle, notice: 'Bundle was successfully created.'
    else
      render :new
    end
  end

  def update
    if @bundle.update(bundle_params)
      redirect_to @bundle, notice: 'Bundle was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @bundle.destroy
    redirect_to bundles_url, notice: 'Bundle was successfully destroyed.'
  end

  private

  def set_bundles
    @bundles = Bundle.all
  end

  def set_bundle
    return if params[:id].nil?
    @bundle = @bundles.find(params[:id]).decorate
  end

  def bundle_params
    params.require(:bundle).permit(:name, :published_at, :account_id)
  end

end
