# Copyright (c) 2016 Nathan Baum

class AccountsController < ApplicationController

  before_action :set_accounts
  before_action :set_account, except: [:new]

  def index
    @accounts = @accounts.order(:id).page(params[:page]).order(:id).decorate
  end

  def new
    @account = @accounts.new
  end

  def create
    @account = @accounts.new(account_params)
    if @account.save
      redirect_to @account, notice: "Account was successfully created."
    else
      render :new
    end
  end

  def update
    if @account.update(account_params)
      redirect_to @account, notice: "Account was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_url, notice: "Account was successfully destroyed."
  end

  private

  def set_accounts
    @accounts = Account.all
  end

  def set_account
    return if params[:id].nil?
    @account = @accounts.find(params[:id]).decorate
  end

  def account_params
    params.require(:account).permit(:name, :balance, :tariff_id, :zone_id)
  end

end
