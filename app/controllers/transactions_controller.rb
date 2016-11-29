# Copyright (c) 2016 Nathan Baum

class TransactionsController < ApplicationController

  before_action :set_transactions
  before_action :set_transaction, except: [:new]

  def index
    @transactions = @transactions.order(:id).page(params[:page]).decorate
  end

  def new
    @transaction = @transactions.new
  end

  def create
    @transaction = @transactions.new(transaction_params)
    if @transaction.save
      redirect_to @transaction, notice: "Transaction was successfully created."
    else
      render :new
    end
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: "Transaction was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: "Transaction was successfully destroyed."
  end

  private

  def set_transactions
    @transactions = Transaction.all
  end

  def set_transaction
    return if params[:id].nil?
    @transaction = @transactions.find(params[:id]).decorate
  end

  def transaction_params
    params.require(:transaction).permit(:rate, :description, :account_id, :kind, :period, :closed_at)
  end

end
