Delayed::Worker.destroy_failed_jobs = false    # 失敗したジョブのレコードを削除するか
Delayed::Worker.sleep_delay = 15               # ジョブが無い場合のスリープ時間
Delayed::Worker.max_attempts = 1               # 最大試行回数（失敗時のリトライ制限）
Delayed::Worker.max_run_time = 60.minutes      # 処理時間の上限
Delayed::Worker.read_ahead = 1                 # ジョブ検索時に取得するレコード数
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'), 14, 50*1024*1024)


# ジョブ検索SQLのデバッグログが大量に出力されるので、それを抑制するパッチ。
# production環境は `config.log_level = :info` にしているので本処理は不要。
if Rails.env.development?
  module Delayed
    module Backend
      module ActiveRecord
        class Job
          class << self
            alias_method :reserve_original, :reserve
            def reserve(worker, max_run_time = Worker.max_run_time)
              previous_level = ::ActiveRecord::Base.logger.level
              ::ActiveRecord::Base.logger.level = Logger::WARN if previous_level < Logger::WARN
              value = reserve_original(worker, max_run_time)
              ::ActiveRecord::Base.logger.level = previous_level
              value
            end
          end
        end
      end
    end
  end
end
