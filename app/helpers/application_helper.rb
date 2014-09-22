module ApplicationHelper

  def convert_options_to_data_attributes (options, html_options)
    url = url_for(options)
    path = request.path
    path += "?" + request.query_string unless request.query_string == ""
    html_options ||= {}
    html_options['href'] ||= url
    html_options['path'] = path
    if path == url or (html_options[:exact] != true and path.start_with?(url))
      html_options['class'] = "active"
      html_options['href'] = nil if path == url
    end
    html_options.delete(:exact)
    super(options, html_options)
  end

  def link_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options ||= {}
    html_options = convert_options_to_data_attributes(options, html_options)
    content_tag(:a, name || url, html_options, &block)
  end

  def page_title (*parts)
    (@page_title = parts.empty? ? @page_title : parts) || []
  end

  def icon (icon, text)
    text
  end

  def crumb (name, link = nil)
    
  end

end
