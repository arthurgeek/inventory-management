# frozen_string_literal: true

module Reports
  class SalesRevenue < Base
    def initialize(location:)
      super(location)
    end

    def name
      'Total revenue from all sales'
    end

    def value
      @location.sales.sum('menus.price')
    end
  end
end
