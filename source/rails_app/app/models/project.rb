# == Schema Information
#
# Table name: projects
#
#  id         :bigint(8)        not null, primary key
#  deleted_at :datetime
#  end_date   :date
#  name       :string(255)      not null
#  start_date :date
#  summary    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ApplicationRecord

  has_many :tickets
  has_many :active_tickets, -> { where("tickets.status <> ?", Ticket.status_value[:end]) }, class_name: 'Ticket'

  scope :active, -> {where(deleted_at: nil)}

  validates :name, presence: true
end
