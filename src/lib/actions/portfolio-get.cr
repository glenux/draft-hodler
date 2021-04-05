
require "../actions"

module Hodler
  class GetPortfolioAction < Action
    # Display Wallet, Symbol, Held, Initial Value, Current Value, Evolution (%)
    def perform
      portfolio = PortfolioFactory.build(@global_options, @config)
      puts portfolio.symbol_report
    end
  end
end
