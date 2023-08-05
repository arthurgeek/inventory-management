# frozen_string_literal: true

class StockChange < ApplicationRecord
  belongs_to :location
  belongs_to :staff
  has_many :inventory_item_changes, as: :change # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :inventory_items, through: :inventory_item_changes
end
