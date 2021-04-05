
require "option_parser"
require "yaml"
require "colorize"
require "xdg_basedir"
require "completion"
require "log"

require "../lib/version"
require "../lib/types"
require "../lib/models"
require "../lib/actions"
require "../lib/models"

module Hodler
  class CtlCli

    property config : ConfigModel?
    property options : GlobalOptions?

    def initialize
      @config = nil
      @options = nil
    end

    def self.parse_options(args) : GlobalOptions
      # default values
      action = ReportAction
      config_file = XDGBasedir.full_path("hodler/wallet.yml", :config, :read).as(String)
      verbose_enable = true

      # parse
      OptionParser.parse(args) do |parser|
        parser.banner = "Usage: #{Version::PROGRAM} [options] [commands] [arguments]"

        parser.separator
        parser.separator "Options"

        parser.on "-c CONFIG_FILE", "--config=CONFIG_FILE", "Use the following config file" do |file|
          config_file = file
        end

        parser.on "-v", "--verbose", "Be verbose" do
          verbose_enable = !verbose_enable
        end

        parser.on "--version", "Show version" do
          puts "version #{Version::VERSION}"
          exit 0
        end

        parser.on "-h", "--help", "Show this help" do
          puts parser
          exit 0
        end

        parser.on "--completion", "Provide autocompletion for bash" do
          # nothing here
        end
        complete_with Version::PROGRAM, parser

        parser.separator
        parser.separator "Commands"

        parser.on("get", "Get given object") do
          parser.banner = "Usage: #{Version::PROGRAM} get [arguments]"

          parser.separator
          parser.separator "Commands"

          parser.on("portfolio", "Show current portfolio") do
            parser.banner = "Usage: #{Version::PROGRAM} portfolio [arguments]"
            action = GetPortfolioAction
          end

          parser.on("wallet", "Show given wallet") do
            parser.banner = "Usage: #{Version::PROGRAM} portfolio [arguments]"
            action = GetWalletAction
          end
        end

        # parser.on("tui", "Run ncurses interactive UI") do
        #   parser.banner = "Usage: #{Version::PROGRAM} tui [arguments]"
        #   action = TextUiAction
        # end

        # parser.on("web", "Run web interactive UI") do
        #   parser.banner = "Usage: #{Version::PROGRAM} web [arguments]"
        #   action = WebUiAction
        # end

        parser.separator

        parser.missing_option do |flag|
          STDERR.puts parser
          STDERR.puts "ERROR: #{flag} requires an argument.".colorize(:red)
          exit(1)
        end

        parser.invalid_option do |flag|
          STDERR.puts parser
          STDERR.puts "ERROR: #{flag} is not a valid option.".colorize(:red)
          exit(1)
        end

        parser.unknown_args do |unknown_args|
          unknown_args = unknown_args - %w(report web tui)
          next if unknown_args.empty?

          STDERR.puts parser
          STDERR.puts "ERROR: \"#{unknown_args[0]}\" is not a valid command.".colorize(:red)
          exit(1)
        end

      end

      return {
        verbose_enable: verbose_enable,
        config_file: config_file,
        action: action
      }.as(GlobalOptions)
    end

    def self.parse_config(options)
      config_file = options[:config_file]
      puts "Loading configuration... #{config_file}".colorize(:yellow) if options[:verbose_enable]

      if ! File.exists? config_file
        STDERR.puts "ERROR: Unable to read configuration file '#{config_file}'".colorize(:red)
        exit 1
      end

      yaml_str = File.read(config_file)
      config = ConfigModel.from_yaml(yaml_str)

      if config.nil?
        STDERR.puts "ERROR: Invalid YAML content in '#{config_file}'"
        exit 1
      end

      return config
    end

    def self.run(args)
      app = CtlCli.new
      options = CtlCli.parse_options(args)
      config = CtlCli.parse_config(options)
      app.options = options
      app.config = config

      action = ActionFactory.build(options, config)
      action.perform

    rescue ex : YAML::ParseException
      STDERR.puts "ERROR: #{ex.message}".colorize(:red)
    end
  end
end

Hodler::CtlCli.run(ARGV)

