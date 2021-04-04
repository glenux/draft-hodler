
require "../models"

module Hodler
  class WalletModel < Model
    enum Type
      Web
      Software
      Cold
    end

    property name : String
    property type : Type
    property refs : Array(RefWalletModel)

    def initialize(name, type : Type)
      @name = name
      @type = type
      @refs = [] of RefWalletModel
    end

    def add_symbol
    end

    def remove_symbol
    end

    def add_transaction
    end

    def remove_transaction
    end
  end
end
