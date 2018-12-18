ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'fixture_parts_helper'
require 'carrierwave_test_helper'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end


class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # @override Devise::Test::IntegrationHelpers#sign_in
  def sign_in(user, project_id=nil)
    super(user)
    select_project(project_id) if project_id.present?
  end

  def select_project(project_id)
    post(api_select_project_path, params: {project_id: project_id})
  end
end