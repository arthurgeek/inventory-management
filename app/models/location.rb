# frozen_string_literal: true

class Location < ApplicationRecord
  has_and_belongs_to_many :staffs # rubocop:todo Rails/HasAndBelongsToMany
end