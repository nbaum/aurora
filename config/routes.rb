class IfViewExists < ActionView::LookupContext
  def initialize
    super(p Rails.root.join('app', 'views'))
  end
  def matches? (request)
    template_exists?("pages" + File.expand_path(request.params["path"], "/"))
  end
end

Rails.application.routes.draw do
  root 'pages#view'
  get  '*path', to: 'pages#view', constraints: IfViewExists.new
end
