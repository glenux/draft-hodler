
require "yaml"

module Hodler
  class Model
    include YAML::Serializable
  end
end

require "./types"
require "./models/config"
require "./models/deposit"
require "./models/fee_trade"
require "./models/portfolio"
require "./models/ref_wallet"
require "./models/trade"
require "./models/transaction_trade"
require "./models/ui_config"
require "./models/wallet"
require "./models/wallet_value_trade"

