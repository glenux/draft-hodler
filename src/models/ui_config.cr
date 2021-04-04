
require "../models"

module Hodler
  class UiConfigModel < Model

    property refresh_per_sec : UInt32
    property default_sym     : String
    property columns         : Array(String)
  end
end
