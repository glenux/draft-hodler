
require "../actions"

module Hodler
  class GetPortfolioAction < Action
    def self.match(action)
      # return (action == Action::Type::Report)
    end

    # Display Wallet, Symbol, Held, Initial Value, Current Value, Evolution (%)
    def perform
      portfolio = PortfolioFactory.build(@global_options, @config)
      puts portfolio.to_report
    end
  end
end
