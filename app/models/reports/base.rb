# frozen_string_literal: true

module Reports
  class Base
    def initialize(location)
      @location = location
    end

    def to_partial_path
      'reports/report'
    end
  end
end
