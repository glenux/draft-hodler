
require "../models"

module Hodler
  class TradeModel < Model
    include YAML::Serializable

    property id          : String?
    property date        : String
    property transaction : TransactionTradeModel
  end
end
