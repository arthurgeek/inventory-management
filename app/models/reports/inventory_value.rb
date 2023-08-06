# frozen_string_literal: true

module Reports
  class InventoryValue < Base
    def initialize(location:)
      super(location)
    end

    def name
      'Total value of current inventory'
    end

    def value
      @location.inventory_items.joins(:ingredient).sum('inventory_items.quantity * ingredients.cost')
    end
  end
end
