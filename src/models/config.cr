
require "../models"

module Hodler
  class ConfigModel < Model

    property version  : String
    property ui       : UiConfigModel
    property wallets  : Array(WalletModel)
    property deposits : Array(DepositModel)
    property trades   : Array(TradeModel)
  end
end
