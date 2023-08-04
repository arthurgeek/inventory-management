# frozen_string_literal: true

class InventoryItemChange < ApplicationRecord
  belongs_to :inventory_item
  belongs_to :change, polymorphic: true
end
