class NotificationDeliverJob < ApplicationJob
  queue_as :default

  # 例外時の処理
  rescue_from(StandardError) do |e|
    Delayed::Worker.logger.error("メール送信に失敗しました。")
    raise e
  end

  # 全ユーザーにメール送信
  def perform
    users = User.where(:deleted_at => nil)
    users.each do |user|
      SystemMailer.send_notification(user).deliver
    end
  end

end
