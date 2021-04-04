
require "../models"

module Hodler
  class FeeTradeModel < Model
    property amount : AmountT
    property sym    : String
  end
end
