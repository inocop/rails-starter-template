class Ticket < ApplicationRecord
  mount_uploader :attachment_file, TicketAttachmentFileUploader

  STATUS_LIST = {
    STATUS_DRAFT = 0 => "未設定",
    STATUS_START = 1 => "着手中",
    STATUS_END   = 2 => "完了"
  }
  enum status_value: { draft: STATUS_DRAFT, start: STATUS_START, end: STATUS_END }

  belongs_to :project
  belongs_to :user, foreign_key: 'assigned_user_id', primary_key: 'id', class_name: "User"

  validates :name,   presence: true
end
