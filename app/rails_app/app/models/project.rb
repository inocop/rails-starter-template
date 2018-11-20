class Project < ApplicationRecord

  has_many :tickets
  has_many :active_tickets, -> { where("tickets.status <> ?", Ticket.status_value[:end]) }, class_name: 'Ticket'

  validates :name, presence: true
end
