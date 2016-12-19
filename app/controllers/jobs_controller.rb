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

  def destroy
    @job.destroy
    redirect_to :back
  end

  def restart
    @job.update! status: "pending"
    redirect_to :back
  end

  def show
    render @job.job.class.name.underscore
  end

  private

  def set_jobs
    @jobs = current_user.jobs
  end

  def set_job
    return if params[:id].nil?
    @job = @jobs.find(params[:id]).decorate
  end

end
