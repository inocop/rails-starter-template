namespace :batch do
  namespace :delete_db do

    desc "保存期間を過ぎたDBデータの物理削除"
    task :run => :environment do
      Rails.logger.info "Start batch:delete_db:run"

      Batch::DestroyProjectService.new.run

      Rails.logger.info "End batch:delete_db:run"
    end

  end
end
