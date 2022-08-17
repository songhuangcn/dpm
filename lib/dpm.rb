# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"

require_relative "dpm/version"
require_relative "dpm/errors"
require_relative "dpm/options"
require_relative "dpm/runner"

module DPM
  ROOT = File.expand_path("..", __dir__).freeze
  HOME = File.expand_path("~/.dpm").freeze

  def self.call!(argv)
    options = Options.parse!(argv)
    Runner.call!(options)
  rescue Error => exception
    puts "Error: #{exception.message}"
  end
end
