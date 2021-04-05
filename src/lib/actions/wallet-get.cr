
require "../actions"

module Hodler
  class GetWalletAction < Action
    def perform
      portfolio = PortfolioFactory.build(@global_options, @config)
      puts portfolio.wallet_report
    end
  end
end
