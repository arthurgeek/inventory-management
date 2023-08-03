# frozen_string_literal: true

require 'test_helper'

class DefaultLocationTest < ActionDispatch::IntegrationTest
  test "it returns an error message when configured location doesn't exist" do
    get '/'

    assert_response :not_found

    assert_select 'h2', 'Default location not found'
  end
end
