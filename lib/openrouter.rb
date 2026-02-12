# frozen_string_literal: true

module Openrouter
  module_function

  def config
    @config ||= Openrouter::Configuration.new
  end
end
