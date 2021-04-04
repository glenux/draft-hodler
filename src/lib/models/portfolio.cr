
require "../models"

module Hodler
  class PortfolioModel < Model

    property wallets : Array(WalletModel)


    def initialize()
      @wallets = [] of WalletModel
    end

    def import_wallets(wallets : Array(WalletModel))
      wallets.each do |wallet|
        @wallets << wallet
      end
    end

    def add_wallet
    end

    def remove_wallet
    end

    def to_report
      data = @wallets.map{|row| [row.name, row.type.to_s, row.refs.map{|ref| ref.sym}.join(", ")] }
      # pp data
      table = Tablo::Table.new(data, connectors: Tablo::CONNECTORS_SINGLE_ROUNDED) do |t|
        t.add_column("Name") { |row| row[0] }
        t.add_column("Type") { |row| row[1] }
        t.add_column("Symbols", width: 40) { |row| row[2] }
      end
    end
  end

  class PortfolioFactory
    def self.build(options : GlobalOptions, config : ConfigModel) : PortfolioModel
      portfolio = PortfolioModel.new

      portfolio.import_wallets(config.wallets)

      return portfolio
    end
  end
end
