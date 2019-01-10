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

  enum status_value: { draft: TicketConst::STATUS_DRAFT,
                       start: TicketConst::STATUS_START,
                         end: TicketConst::STATUS_END,
                      cancel: TicketConst::STATUS_CANCEL, }

  mount_uploader :attachment_file, TicketAttachmentFileUploader

  belongs_to :project
  belongs_to :user, foreign_key: 'assigned_user_id', primary_key: 'id', class_name: "User"

  scope :active,    -> {where(deleted_at: nil)}
  scope :completed, -> {where(status: TicketConst::STATUS_GROUP_IDS[TicketConst::GROUP_COMPLETE])}
  scope :progress,  -> {where.not(status: TicketConst::STATUS_GROUP_IDS[TicketConst::GROUP_PROGRESS])}

  validates :name, presence: true

end
