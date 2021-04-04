
require "./actions/*"

module Hodler
  alias AmountT = Float64 | Int64

  alias GlobalOptions = {
    action: Action.class,
    verbose_enable: Bool,
    config_file: String
  }
end
