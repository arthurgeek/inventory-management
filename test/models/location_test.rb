# frozen_string_literal: true

require 'test_helper'
require 'ostruct'

class LocationTest < ActiveSupport::TestCase
  describe 'current' do
    before do
      @config = OpenStruct.new({ name: 'Location Name' }) # rubocop:disable Style/OpenStructUse
    end

    describe 'when configured Location exists' do
      it('returns the location from database') do
        @location = Location.create({ name: @config.name })

        assert_equal(Location.current(@config), @location)

        @location.destroy
      end
    end

    describe 'when configured Location does not exists' do
      it('returns an error') do
        assert_raises(DefaultLocationNotFound) { Location.current(@config) }
      end
    end
  end
end
