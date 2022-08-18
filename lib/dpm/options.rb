require "optparse"

module DPM
  class Options
    PACKAGE_COMMANDS = %w[tags status start stop restart].freeze
    PACKAGE_REGEX = /\A[\w.\-:]+\z/.freeze
    UNPACKAGE_COMMANDS = %w[list packages].freeze

    attr_accessor :argv, :dry_run, :parser, :command, :package

    def initialize(argv)
      self.argv = argv
      self.dry_run = false
    end

    def self.parse!(argv)
      new(argv).parse!
    end

    def parse!
      OptionParser.new do |parser|
        self.parser = parser

        parser.banner = "Usage: dpm [options] [COMMAND] [PACKAGE]"
        parser.separator ""
        parser.separator "Specific options:"

        parser.on("-d", "--dry-run", "Don't actually run anything, just print") do |v|
          self.dry_run = v
        end

        parser.separator ""
        parser.separator "Common options:"

        parser.on_tail("-h", "--help", "Show the help") do
          puts help_text
          exit
        end

        parser.on_tail("-v", "--version", "Show the version") do
          puts VERSION
          exit
        end

        parser.parse!(argv)
      end

      process_args!
      self
    end

    def help_text
      <<~EOF
        #{parser}
        COMMAND:
            help                             Show the help
            version                          Show the version
            packages                         List supported packages
            list                             List running packages
            tags PACKAGE                     List supported tags of a package
            status PACKAGE                   Get the status of a package
            start PACKAGE                    Start a package
            stop PACKAGE                     Stop a package
            restart PACKAGE                  Restart a package

        See more at https://github.com/songhuangcn/dpm
      EOF
    end

    def process_args!
      self.command, self.package = argv

      case command
      when "help"
        puts help_text
        exit
      when "version"
        puts VERSION
        exit
      when *PACKAGE_COMMANDS
        raise Error, "Command `#{command}` need a package" if package.blank?
        raise Error, "Package invalid, valid regex: #{PACKAGE_REGEX}" if !PACKAGE_REGEX.match?(package)
      else
        raise Error, "Unknown command `#{command}`, see `dpm help`" unless UNPACKAGE_COMMANDS.include?(command)
      end
    end
  end
end
