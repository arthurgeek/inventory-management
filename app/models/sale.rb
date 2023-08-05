# frozen_string_literal: true

class Sale < ApplicationRecord
  belongs_to :location
  belongs_to :staff
  belongs_to :menu
  has_many :inventory_item_changes, as: :change # rubocop:todo Rails/HasManyOrHasOneDependent
end
