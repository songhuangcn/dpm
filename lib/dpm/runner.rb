# frozen_string_literal: true

require "yaml"
require "erb"

module DPM
  class Runner
    PACKAGE_COMMANDS = %w[status start stop restart].freeze
    PACKAGE_REGEX = /\A[\w.\-:]+\z/.freeze
    CONTAINER_NAME_PREFIX = "dpm-"
    BASH_COLOR_GRAY = "\033[0;37m"
    BASH_COLOR_NONE = "\033[0m"

    attr_reader :command, :package

    def self.call!(argv)
      new(argv).call!
    end

    def initialize(argv)
      @command, @package = argv
      validate_argv!
    end

    def call!
      if docker_command
        puts bash_color(docker_command)
        puts ""
        puts `#{docker_command}`
      else
        puts help_text
      end
    end

    private

    def validate_argv!
      if PACKAGE_COMMANDS.include?(command) && !PACKAGE_REGEX.match?(package)
        raise Error, "`package` invalid, valid regex: #{PACKAGE_REGEX}"
      end
    end

    def bash_color(text)
      "#{BASH_COLOR_GRAY}#{text}#{BASH_COLOR_NONE}"
    end

    def docker_command
      case command
      when "list"
        %(docker ps --filter "name=#{CONTAINER_NAME_PREFIX}")
      when "status"
        %(docker ps --filter "name=#{container_name}")
      when "start"
        "docker run #{docker_run_params}"
      when "stop"
        "docker stop #{container_name}"
      when "restart"
        "dpm stop #{package} && dpm start #{package}"
      end
    end

    def help_text
      <<~EOF
        Usage: dpm command [PACKAGE]

        Docker Package Manager

        dpm help:
            Show the help
        dpm list:
            List running packages
        dpm status PACKAGE:
            Get the status of the package
        dpm start PACKAGE:
            Start the package
        dpm stop PACKAGE:
            Stop the package
        dpm restart PACKAGE:
            Restart the package

        See more at https://github.com/songhuangcn/dpm
      EOF
    end

    def docker_run_params
      @docker_run_params ||= [config_run_options, docker_image, config_command, config_args].select(&:present?).join(" ")
    end

    def config_run_options
      process_options(manager_config["run_options"])
    end

    def config_command
      manager_config["command"]
    end

    def config_args
      process_options(manager_config["args"])
    end

    def process_options(hash)
      return "" unless hash

      hash = hash.reject { |key, value| value == false }
      hash_arr = hash.map do |key, value|
        if key.length == 1
          option_prefix = "-"
          value_joiner = " "
        else
          option_prefix = "--"
          value_joiner = "="
        end

        if value == true
          "#{option_prefix}#{key}"
        elsif value.is_a?(Array)
          value.map { |v| "#{option_prefix}#{key}#{value_joiner}#{v}" }.join(" ")
        else
          "#{option_prefix}#{key}#{value_joiner}#{value}"
        end
      end
      hash_arr.join(" ")
    end

    def docker_image
      image_tag ? "#{image_name}:#{image_tag}" : image_name
    end

    def image_name
      @image_name ||= manager_config["image_name"] || package_name
    end

    def image_tag
      @image_tag ||= manager_config["image_tag"] || package_tag
    end

    def manager_config
      @manager_config ||= begin
        default_options = load_yaml(File.join(ROOT, "packages", "default.yml"))
        image_options = load_yaml(File.join(ROOT, "packages", package_name, "default.yml"))
        tag_options = load_yaml(File.join(ROOT, "packages", package_name, "tag-#{package_tag}.yml"))

        default_options \
          .deep_merge(image_options) \
          .deep_merge(tag_options)
      end
    end

    def package_name
      @package_name ||= package.split(":")[0]
    end

    def package_tag
      @package_tag ||= package.split(":")[1]
    end

    def container_name
      @container_name ||= "#{CONTAINER_NAME_PREFIX}#{package.tr(":", "-")}"
    end

    def load_yaml(file_path)
      text = File.read(file_path)
      data = ERB.new(text).result(binding)
      YAML.safe_load(data).tap do |yaml|
        raise Error, "Config need to be a hash yaml: #{file_path}" unless yaml.is_a?(Hash)
      end
    rescue Errno::ENOENT
      {}
    end
  end
end
