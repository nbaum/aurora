class UsersController < ApplicationController

  before_action :set_users
  before_action :set_user, except: [:new]

  def index
    @users = @users.order(:id).page(params[:page]).decorate
  end

  def new
    @user = @users.new
  end

  def create
    @user = @users.new(user_params)
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_users
    @users = User.all
  end

  def set_user
    return if params[:id].nil?
    @user = @users.find(params[:id]).decorate
  end

  def user_params
    params.require(:user).permit(:name, :email, :password_digest, :account_id, :administrator, :ssh_keys)
  end

end
