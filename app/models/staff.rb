# frozen_string_literal: true

class Staff < ApplicationRecord
  has_and_belongs_to_many :locations # rubocop:todo Rails/HasAndBelongsToMany
  has_many :inventory_item_changes # rubocop:todo Rails/HasManyOrHasOneDependent
end
