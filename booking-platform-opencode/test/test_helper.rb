ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/autorun"

module ActiveSupport
  class TestCase
    fixtures :all

    setup do
      @org = organizations(:one)
      @service = services(:one)
    end
  end
end
