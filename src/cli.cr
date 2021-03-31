
module Hodler
  class Cli
    alias Options = {
      wallet_file: String,
    }

    # @config : Config?
    @options : Options?

    def initialize
      # @config = nil
      @options = nil
    end

    def parse_options(args) : Options
      # default values
      wallet_file = XDGBasedir.full_path("hodler/wallet.yml", :config, :read).as(String)

      # parse
      OptionParser.parse(args) do |parser|
        parser.banner = "Usage: hodler [arguments]"

        parser.on "-w WALLET_FILE", "--wallet=WALLET_FILE", "Use the following wallet file" do |file|
          wallet_file = file
        end

        # parser.on "-f DOCKER_COMPOSE_YML", "--config=DOCKER_COMPOSE_YML", "Use the following docker-compose file" do |file|
        #   docker_compose_yml = file
        # end

        parser.on "-v", "--version", "Show version" do
          puts "version #{Version::VERSION}"
          exit 0
        end
        parser.on "-h", "--help", "Show help" do
          puts parser
          exit 0
        end

        complete_with "hodler", parser
      end

      @options = {
        wallet_file: wallet_file
      }

      return @options.as(Options)
    end

    def self.run(args)
      app = Cli.new
      app.parse_options(args)
      # config = app.load_config(opts["config_file"])
      # env_config = App.get_config(config, opts["environment"])
    end
  end
end
