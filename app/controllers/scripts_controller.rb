class ScriptsController < ApplicationController

  before_action :set_scripts
  before_action :set_script, except: [:new]

  def index
    @scripts = @scripts.order(:id).page(params[:page]).decorate
  end

  def new
    @script = @scripts.new
  end

  def create
    @script = @scripts.new(script_params)
    if @script.save
      redirect_to @script, notice: 'Script was successfully created.'
    else
      render :new
    end
  end

  def update
    if @script.update(script_params)
      redirect_to :back, notice: 'Script was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @script.destroy
    redirect_to scripts_url, notice: 'Script was successfully destroyed.'
  end

  private

  def set_scripts
    @scripts = Script.all
  end

  def set_script
    return if params[:id].nil?
    @script = @scripts.find(params[:id]).decorate
  end

  def script_params
    params.require(:script).permit(:name, :category, :script, :steps)
  end

end
