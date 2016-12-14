class Script < ActiveRecord::Base

  before_save do
    script.gsub!(/\r/, '')
  end

end
