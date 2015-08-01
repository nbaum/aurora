# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

module Admin

  class AppliancesController < ApplicationController

    before_action :set_appliances
    before_action :set_appliance, except: [:new]

    def index
      @appliances = @appliances.order(:id).page(params[:page]).decorate
    end

    def new
      @appliance = @appliances.new
    end

    def create
      @appliance = @appliances.new(appliance_params)
      if @appliance.save
        redirect_to @appliance, notice: "Appliance was successfully created."
      else
        render :new
      end
    end

    def update
      if @appliance.update(appliance_params)
        redirect_to @appliance, notice: "Appliance was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @appliance.destroy
      redirect_to appliances_url, notice: "Appliance was successfully destroyed."
    end

    private

    def set_appliances
      @appliances = Appliance.all
    end

    def set_appliance
      return if params[:id].nil?
      @appliance = @appliances.find(params[:id]).decorate
    end

    def appliance_params
      params.require(:appliance).permit(:name, :internal_class, :template_id)
    end

  end

end
