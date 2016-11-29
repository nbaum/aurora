# Copyright (c) 2016 Nathan Baum

class TransactionDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

end
