# == Schema Information
#
# Table name: projects
#
#  id         :bigint(8)        not null, primary key
#  deleted_at :datetime
#  end_date   :date
#  name       :string(255)      not null
#  start_date :date
#  summary    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  setup do
    load_fixture_parts("models/project_test.yml")
  end

  # test "the truth" do
  #   assert true
  # end
end
