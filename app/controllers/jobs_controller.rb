class JobsController < ApplicationController

  before_action :set_jobs
  before_action :set_job, except: [:new]

  def index
    @jobs = @jobs.order(:id).page(params[:page]).decorate
  end

  def new
    @job = @jobs.new
  end

  def create
    @job = @jobs.new(job_params)
    if @job.save
      redirect_to @job, notice: 'Job was successfully created.'
    else
      render :new
    end
  end

  def update
    if @job.update(job_params)
      redirect_to @job, notice: 'Job was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @job.destroy
    redirect_to jobs_url, notice: 'Job was successfully destroyed.'
  end

  private

  def set_jobs
    @jobs = Job.all
  end

  def set_job
    return if params[:id].nil?
    @job = @jobs.find(params[:id]).decorate
  end

  def job_params
    params.require(:job).permit(:type, :status, :progress, :data)
  end

end
