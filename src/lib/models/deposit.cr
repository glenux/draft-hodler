
require "../models"

module Hodler
  class DepositModel < Model
    include YAML::Serializable

    property id      : String?
    property date    : String
    property deposit : WalletValueTradeModel
  end
end
