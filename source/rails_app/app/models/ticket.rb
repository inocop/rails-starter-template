# == Schema Information
#
# Table name: tickets
#
#  id               :bigint(8)        not null, primary key
#  attachment_file  :string(255)
#  deleted_at       :datetime
#  end_date         :date
#  name             :string(255)      not null
#  start_date       :date
#  status           :integer          default(1)
#  summary          :string(255)
#  work_time        :time
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  assigned_user_id :bigint(8)        not null
#  project_id       :bigint(8)        not null
#

class Ticket < ApplicationRecord
  STATUS_LIST = {
    STATUS_DRAFT  =  1 => "新規",
    STATUS_START  =  2 => "進行中",
    STATUS_END    = 10 => "完了",
    STATUS_CANCEL = 11 => "取消",
  }
  enum status_value: { draft: STATUS_DRAFT,
                       start: STATUS_START,
                         end: STATUS_END,
                      cancel: STATUS_CANCEL, }

  mount_uploader :attachment_file, TicketAttachmentFileUploader

  belongs_to :project
  belongs_to :user, foreign_key: 'assigned_user_id', primary_key: 'id', class_name: "User"

  scope :active,     -> {where(deleted_at: nil)}
  scope :completed,  -> {where(status: [Ticket::STATUS_END, Ticket::STATUS_CANCEL])}
  scope :incomplete, -> {where.not(status: [Ticket::STATUS_END, Ticket::STATUS_CANCEL])}

  validates :name, presence: true

end
