
require "../actions"

module Hodler
  class ReportAction < Action
    def self.match(action)
      return (action == Action::Type::Report)
    end
  end
end
