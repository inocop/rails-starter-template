require 'test_helper'

class DestroyProjectServiceTest < ActiveSupport::TestCase

  setup do
    load_fixture_parts("lib/tasks/modules/destroy_project_test.yml")
  end

  test "論理削除後、1ヶ月経過したプロジェクトが物理削除されること" do
    # 削除処理を実行
    destroy_project = Batch::DestroyProjectService.new
    destroy_project.run

    msg = "削除日から1ヶ月以内のプロジェクトは削除されないこと"
    assert(Project.find_by(:id => 1001).present?, msg)

    msg = "削除日から1ヶ月後のプロジェクトは削除されること"
    assert_not(Project.find_by(:id => 1002).present?, msg)
  end
end