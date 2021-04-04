
require "./models"
require "./actions"
require "./models"

module Hodler
  class Cli
    alias Options = {
      action: Action::Type,
      verbose_enable: Bool,
      config_file: String
    }

    property config : ConfigModel?
    property options : Options?

    def initialize
      @config = nil
      @options = nil
    end

    def self.parse_options(args) : Options
      # default values
      action = Action::Type::Report
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

        parser.on("report", "Compute report") do
          parser.banner = "Usage: #{Version::PROGRAM} list [arguments]"
          action = Action::Type::Report
        end

        parser.on("tui", "Run ncurses interactive UI") do
          parser.banner = "Usage: #{Version::PROGRAM} tui [arguments]"
          action = Action::Type::TextUi
        end

        parser.on("web", "Run web interactive UI") do
          parser.banner = "Usage: #{Version::PROGRAM} web [arguments]"
          action = Action::Type::WebUi
        end

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
      }.as(Options)
    end

    def self.parse_config(options)
      puts "Loading configuration...".colorize(:yellow) if options[:verbose_enable]
      config_file = options[:config_file]

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
      app = Cli.new
      options = Cli.parse_options(args)
      config = Cli.parse_config(options)
      app.options = options
      app.config = config

      portfolio = PortfolioFactory.build(options, config)

      action = ActionFactory.build(options, config)
      action.perform

    rescue ex : YAML::ParseException
      STDERR.puts "ERROR: #{ex.message}".colorize(:red)
    end
  end
end
