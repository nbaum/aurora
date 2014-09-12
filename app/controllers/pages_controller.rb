class PagesController < ApplicationController

  def view
    path = File.expand_path(params[:path] || "root", "/")[1..-1]
    @main_class = params[:path].split("/").join(" ")
    render "pages/#{path}"
  end

end
