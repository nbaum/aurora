class StoragePoolsController < ApplicationController

  before_action :set_storage_pools
  before_action :set_storage_pool, except: [:new]

  def index
    @storage_pools = @storage_pools.page(params[:page]).decorate
  end

  def new
    @storage_pool = @storage_pools.new
  end

  def create
    @storage_pool = @storage_pools.new(storage_pool_params)
    if @storage_pool.save
      redirect_to @storage_pool, notice: 'Storage pool was successfully created.'
    else
      render :new
    end
  end

  def update
    if @storage_pool.update(storage_pool_params)
      redirect_to @storage_pool, notice: 'Storage pool was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @storage_pool.destroy
    redirect_to storage_pools_url, notice: 'Storage pool was successfully destroyed.'
  end

  private

  def set_storage_pools
    @storage_pools = StoragePool.all
  end

  def set_storage_pool
    return if params[:id].nil?
    @storage_pool = @storage_pools.find(params[:id]).decorate
  end

  def storage_pool_params
    params.require(:storage_pool).permit(:name, :size, :account_id, :host_id)
  end

end