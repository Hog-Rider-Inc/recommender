# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  GENERIC_EXCEPTION_CODE = 1000

  rescue_from Exception, with: :exception_handler

  private

  def exception_handler(exception)
    backtrace = Rails.backtrace_cleaner.clean(exception.backtrace)

    if Rails.env.production?
      render status: :internal_server_error
    else
      render json: json(exception, backtrace), status: exception.try(:status) || 500
    end
  end

  def json(exception, backtrace)
    {
      code: exception.try(:code) || GENERIC_EXCEPTION_CODE,
      message: exception.message,
      backtrace: backtrace,
    }
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      token == API_KEY
    end
  end
end
