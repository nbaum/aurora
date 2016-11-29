# Copyright (c) 2016 Nathan Baum

class JobsController < ApplicationController

  before_action :set_jobs
  before_action :set_job, except: [:new]

  def remove_finished
    @jobs.finished.destroy_all
    redirect_to :back
  end

  def index
    @jobs = @jobs.order(:id).page(params[:page]).decorate
  end

  def new
    @job = @jobs.new
  end

  def create
    @job = @jobs.new(job_params)
    if @job.save
      redirect_to @job, notice: "Job was successfully created."
    else
      render :new
    end
  end

  def update
    if @job.update(job_params)
      redirect_to @job, notice: "Job was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @job.destroy
    redirect_to :back
  end

  def restart
    @job.schedule
    redirect_to :back
  end

  def cancel
    @job.cancel
    redirect_to :back
  end

  private

  def set_jobs
    @jobs = current_user.jobs
  end

  def set_job
    return if params[:id].nil?
    @job = @jobs.find(params[:id]).decorate
  end

  def job_params
    params.require(:job).permit(:type, :pending, :data, :state, :owner_id, :server_id)
  end

end
