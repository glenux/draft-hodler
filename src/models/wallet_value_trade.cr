
require "../models"

module Hodler
  class WalletValueTradeModel < Model
    property wallet : String
    property amount : AmountT
    property sym    : String
  end
end
