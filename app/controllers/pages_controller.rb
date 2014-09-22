class PagesController < ApplicationController

  def view
    path = File.expand_path(params[:path] || "index", "/")[1..-1]
    @main_class = params[:path].split("/").join(" ") rescue nil
    render "pages/#{path}"
  end

end
