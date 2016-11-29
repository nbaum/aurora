# Copyright (c) 2016 Nathan Baum

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
      redirect_to @bundle, notice: "Bundle was successfully created."
    else
      render :new
    end
  end

  def update
    if @bundle.update(bundle_params)
      redirect_to @bundle, notice: "Bundle was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @bundle.destroy
    redirect_to bundles_url, notice: "Bundle was successfully destroyed."
  end

  def start
    @bundle.start
    redirect_to @bundle, notice: "Bundle started"
  end

  def pause
    @bundle.pause
    redirect_to @bundle, notice: "Bundle paused"
  end

  def unpause
    @bundle.unpause
    redirect_to @bundle, notice: "Bundle resumed"
  end

  def reset
    @bundle.reset
    redirect_to @bundle, notice: "Bundle reset"
  end

  def stop
    @bundle.stop
    redirect_to @bundle, notice: "Bundle stopped"
  end

  def clone
    new_server = @bundle.clone
    redirect_to new_server, notice: "Bundle copied" if new_server.save
  end

  private

  def set_bundles
    @bundles = Bundle.all
  end

  def set_bundle
    return if params[:id].nil?
    @bundle = @bundles.find(params[:id])
    @bundle = @bundle.decorate unless request.method == "POST"
  end

  def bundle_params
    params.require(:bundle).permit(:name, :published_at, :account_id)
  end

end
