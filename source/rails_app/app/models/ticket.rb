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

  def self.get_tickets(project_id:, completed: false)
    tickets = Ticket.active.where("project_id = ?", project_id)

    if completed
      tickets.completed
    else
      tickets.incomplete
    end
  end

end
