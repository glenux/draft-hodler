
module Hodler
  class Action
    enum Type
      Report
      TextUi
      WebUi
    end

    def self.match(action)
      return false
    end

    def initialize(config : ConfigModel)
      @config = config
    end

    def perform
      wallets = {} of Tuple(String,String) => Float32
      @config.trades.each do |trade|
        tr = trade.transaction
        from_id = {tr.from.wallet, tr.from.sym}
        to_id = {tr.to.wallet, tr.to.sym}
        fee_id = {tr.from.wallet, tr.fee.sym}

        wallets[from_id] ||= 0
        wallets[fee_id] ||= 0
        wallets[to_id] ||= 0
        wallets[from_id] -= tr.from.amount
        wallets[fee_id] -= tr.fee.amount
        wallets[to_id] += tr.to.amount

        pp tr
        pp wallets
      end

    end
  end

  class ActionFactory
    def self.build(options, config)
      action_class = Action
      [ReportAction, WebUiAction, TextUiAction].each do |cls|
        action_class = cls if cls.match(options[:action])
      end
      action = action_class.new(config)
    end
  end
end

require "./actions/report"
require "./actions/tui"
require "./actions/web"

