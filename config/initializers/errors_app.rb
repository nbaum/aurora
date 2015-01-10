Rails.application.config.exceptions_app = lambda do |env|
  Rails.application.routes.call(env.merge("PATH_INFO" => "/errors#{env["PATH_INFO"]}"))
end
