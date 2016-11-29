# Copyright (c) 2016 Nathan Baum
module ApplicationHelper

  def convert_options_to_data_attributes (options, html_options)
    html_options = ActiveSupport::HashWithIndifferentAccess.new(html_options)
    url = case options
          when String
            url_for(options)
          else
            url_for([*options, anchor: (html_options || {})[:anchor]])
          end
    path = request.path
    path += "?" + request.query_string unless request.query_string == ""
    html_options ||= {}
    html_options["href"] ||= url
    if path == url || (html_options[:exact] != true && path.start_with?(url))
      if html_options["class"]
        html_options["class"] << " active"
      else
        html_options["class"] = "active"
      end
      # html_options['href'] = nil if path == url
    end
    html_options.delete(:exact)
    super(options, html_options)
  end

  def link_to(name = nil, options = nil, html_options = nil, &block)
    if block_given?
      html_options = options
      options = name
      name = block
    end
    options ||= {}
    html_options = convert_options_to_data_attributes(options, html_options)
    content_tag(:a, name || url, html_options, &block)
  end

  def icon (icon, text = nil, fw: false, **options)
    options[:class] = "fa-fw" if fw
    options[:text] = text if text
    fa_icon(icon, options)
  end

  def gravatar_url (email, options)
    url = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.strip.downcase)}"
    url = url + "?" + options.to_query unless options.empty?
    url
  end

  def json (data)
    data.to_json.html_safe
  end

end
