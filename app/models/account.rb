# Copyright (c) 2016 Nathan Baum

class Account < ActiveRecord::Base

  belongs_to :tariff
  belongs_to :zone
  has_many :servers
  has_many :transactions

  def balance
    transactions.map(&:amount).reduce(&:+)
  end

  def rate
    txm = transactions.where("period <> 'instant'").group_by(&:period)
    txm.map do |prd, txs|
      [prd, txs.map(&:rate).reduce(&:+)]
    end
  end

  def credit (_kind, amount, description, period = nil)
    debit(type, -amount, description, period)
  end

  def debit (kind, amount, description, period = nil)
    transactions.create!(kind: kind, rate: amount, description: description, period: period)
  end

end
