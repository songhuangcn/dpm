# frozen_string_literal: true

require "yaml"
require "erb"

module DPM
  class Runner
    CONTAINER_NAME_PREFIX = "dpm-"
    BASH_COLOR_GRAY = "\033[0;37m"
    BASH_COLOR_NONE = "\033[0m"

    attr_accessor :options

    def self.call!(options)
      new(options).call!
    end

    def initialize(options)
      self.options = options
    end

    def call!
      if options.dry_run
        puts "Dry run:"
        puts bash_color(docker_command)
      else
        puts bash_color(docker_command)
        puts ""
        puts `#{docker_command}`
      end
    end

    private

    def bash_color(text)
      "#{BASH_COLOR_GRAY}#{text}#{BASH_COLOR_NONE}"
    end

    def docker_command
      case options.command
      when "list"
        %(docker ps --filter "name=#{CONTAINER_NAME_PREFIX}")
      when "status"
        %(docker ps --filter "name=#{container_name}")
      when "start"
        "docker run #{docker_run_params}"
      when "stop"
        "docker stop #{container_name}"
      when "restart"
        "dpm stop #{options.package} && dpm start #{options.package}"
      else
        raise "Not implemented command: `#{command}`"
      end
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
      @package_name ||= options.package.split(":")[0]
    end

    def package_tag
      @package_tag ||= options.package.split(":")[1]
    end

    def container_name
      @container_name ||= "#{CONTAINER_NAME_PREFIX}#{options.package.tr(":", "-")}"
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
