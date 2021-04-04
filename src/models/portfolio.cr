
require "../models"

module Hodler
  class PortfolioModel < Model

    property wallets : Array(WalletModel)


    def initialize
      @wallets = [] of WalletModel
    end

    def import_wallets(wallets : Array(WalletModel))
      wallets.each do |wallet_config|
        wallet = WalletModel.new(wallet_config.name, wallet_config.type)
        # wallet.import(wallet_config)
        pp wallet_config
      end
    end

    def add_wallet
    end

    def remove_wallet
    end
  end

  class PortfolioFactory
    def self.build(options : Cli::Options, config : ConfigModel)
      portfolio = PortfolioModel.new

      portfolio.import_wallets(config.wallets)
    end
  end
end
