class ErrorsController < ApplicationController

  before_action :set_errors
  before_action :set_error, except: [:new]

  def index
    @errors = @errors.order(:id).page(params[:page]).decorate
  end

  def new
    @error = @errors.new
  end

  def create
    @error = @errors.new(error_params)
    if @error.save
      redirect_to @error, notice: 'Error was successfully created.'
    else
      render :new
    end
  end

  def update
    if @error.update(error_params)
      redirect_to @error, notice: 'Error was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @error.destroy
    redirect_to errors_url, notice: 'Error was successfully destroyed.'
  end

  private

  def set_errors
    @errors = Error.all
  end

  def set_error
    return if params[:id].nil?
    @error = @errors.find(params[:id]).decorate
  end

  def error_params
    params.require(:error).permit(:usable_type, :usable_id, :class_name, :message, :trace, :target_url, :referer_url, :params, :user_agent)
  end

end
