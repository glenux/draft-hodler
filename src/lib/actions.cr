
require "tablo"

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

    def initialize(global_options : GlobalOptions, config : ConfigModel)
      @global_options = global_options
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
      end
    end
  end

  class ActionFactory
    def self.build(options, config)
      action = options[:action].new(options, config)
    end
  end
end

require "./actions/*"

