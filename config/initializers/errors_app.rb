Rails.application.config.exceptions_app = lambda do |env|
  self.routes.call(env.merge("PATH_INFO" => "/errors"))
end
