
require "../models"

module Hodler
  class PortfolioModel < Model

    getter wallets : Array(WalletModel)

    def initialize()
      @wallets = [] of WalletModel
      @trades = [] of TradeModel
      @deposits = [] of DepositModel
    end

    def import_deposits(deposits : Array(DepositModel))
      @deposits = deposits
    end

    def import_wallets(wallets : Array(WalletModel))
      @wallets = wallets
    end

    def import_trades(trades : Array(TradeModel))
      @trades = trades
    end

    def add_wallet
    end

    def remove_wallet
    end

    def symbol_report
      wallets = {} of Tuple(String,String) => Float32
      @deposits.each do |deposit_wrapper|
        deposit = deposit_wrapper.deposit
        id = {deposit.wallet, deposit.sym}
        wallets[id] ||= 0
        wallets[id] += deposit.amount
      end

      @trades.each do |trade_wrapper|
        trade = trade_wrapper.transaction
        from_id = {trade.from.wallet, trade.from.sym}
        to_id = {trade.to.wallet, trade.to.sym}
        fee_id = {trade.from.wallet, trade.fee.sym}

        wallets[from_id] ||= 0
        wallets[fee_id] ||= 0
        wallets[to_id] ||= 0
        wallets[from_id] -= trade.from.amount
        wallets[fee_id] -= trade.fee.amount
        wallets[to_id] += trade.to.amount
      end
      data = [] of Array(String)
      wallets
        .each{|key, val| data << [ key[0], key[1].to_s, "%f" % val] }
      data.sort! do |x,y| 
        resA = x[0] <=> y[0]
        resB = x[1] <=> y[1] 
        ((resA == 0) ? resB : resA)
      end

      table = Tablo::Table.new(data, connectors: Tablo::CONNECTORS_SINGLE_ROUNDED) do |t|
        t.add_column("Wallet") { |row| row[0] }
        t.add_column("Symbol") { |row| row[1] }
        t.add_column("Held", align_header: Tablo::Justify::Right, align_body: Tablo::Justify::Right) { |row| row[2] }
        t.add_column("Invested") { |row| "FIXME" }
        t.add_column("Cur. Price") { |row| "FIXME" }
        t.add_column("Cur. Value") { |row| "FIXME" }
      end
    end

    def wallet_report
      data = @wallets.map{|row| [row.name, row.type.to_s, row.refs.map{|ref| ref.sym}.join(",")] }
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
      portfolio.import_trades(config.trades)
      portfolio.import_deposits(config.deposits)

      return portfolio
    end
  end
end
