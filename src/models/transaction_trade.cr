
require "yaml"

module Hodler
  class TransactionTradeModel < Model
    property from : WalletValueTradeModel
    property to   : WalletValueTradeModel
    property fee  : FeeTradeModel
  end
end

