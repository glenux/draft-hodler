
require "../actions"

module Hodler
  class TextUiAction < Action
    def self.match(action)
      return (action == Action::Type::TextUi)
    end
  end
end
