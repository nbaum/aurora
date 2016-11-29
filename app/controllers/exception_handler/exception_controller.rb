# Copyright (c) 2016 Nathan Baum

module ExceptionHandler

  class ExceptionController < ::ApplicationController

		skip_before_filter :check_authentication

    respond_to :html, :xml, :json
    before_action :status, :app_name

    layout :layout_status

    def show
      respond_with status: @status
    end

    protected

    def status
      @exception  = env["action_dispatch.exception"]
      @status     = ActionDispatch::ExceptionWrapper.new(env, @exception).status_code
      @response   = ActionDispatch::ExceptionWrapper.rescue_responses[@exception.class.name]
    end

    def details
      @details ||= {}.tap do |h|
        I18n.with_options scope: [:exception, :show, @response], exception_name: @exception.class.name, exception_message: @exception.message do |i18n|
          h[:name]    = i18n.t "#{@exception.class.name.underscore}.title", default: i18n.t(:title, default: @exception.class.name)
          h[:message] = i18n.t "#{@exception.class.name.underscore}.description", default: i18n.t(:description, default: @exception.message)
        end
      end
    end

    helper_method :details

    private

    def layout_status
      @status.to_s != "404" ? "error" : "bare"
    end

    def app_name
      @app_name = Rails.application.class.parent_name
    end

  end

end
