class DestroyProject

  def initialize
   @one_years_ago = Time.current.ago(1.years)
  end

  def run
    begin
      ActiveRecord::Base.transaction do
        destroy_deleted_projects
      end
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  # 論理削除プロジェクトの物理削除
  def destroy_deleted_projects
    targets_projects = Project.where.not(:deleted_at => nil).where("deleted_at < ?", @one_years_ago)
    destroy(targets_projects)
  end

  # Projectの物理削除
  # @params ProjectモデルのRelation
  #
  # @return void
  private def destroy(projects)
    projects.find_each(batch_size: 1000) do |project|
      project.destroy!    # destroyでCarrierWaveの添付ファイルも削除
    end
  end
end