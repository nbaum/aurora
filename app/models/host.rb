class Host < ActiveRecord::Base
  belongs_to :zone

  def api (args = {})
    zone.api(url, args)
  end

end
