
require "../actions"

module Hodler
  class WebUiAction < Action
    def self.match(action)
      return (action == Action::Type::WebUi)
    end
  end
end
