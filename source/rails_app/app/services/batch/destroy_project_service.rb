class Batch::DestroyProjectService

  attr_reader :error_message

  def initialize
   @one_month_ago = Time.current.ago(1.months)
  end

  def run
    ApplicationRecord.transaction do
      # 論理削除プロジェクトを物理削除
      targets_projects = Project.where.not(:deleted_at => nil).where("deleted_at < ?", @one_month_ago)
      destroy(targets_projects)
    end
  rescue => e
    @error_message = e.message
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace.join("\n"))

    # バッチ処理の失敗をメールで通知
    SystemMailer.send_error(exception: e).deliver
  end

  # DB物理削除
  # @params ProjectモデルのRelation
  #
  # @return void
  private def destroy(projects)
    projects.find_each(batch_size: 1000) do |project|
      # 関連するチケットを削除
      Ticket.where(project_id: project.id).destroy_all  # destroyでCarrierWaveのファイルごと削除
      project.destroy!
    end
  end
end