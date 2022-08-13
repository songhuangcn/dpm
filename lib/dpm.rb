# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"

require_relative "dpm/version"
require_relative "dpm/errors"
require_relative "dpm/runner"

module DPM
  ROOT = File.expand_path("..", __dir__).freeze
  HOME = File.expand_path("~/.dpm").freeze
end
