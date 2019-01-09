class TicketDao

  def initialize(ticket)
    unless ticket.instance_of?(Ticket)
      raise 'InvalidArgClass'
    end
    @ticket = ticket
  end

  # 対象プロジェクトのチケットリストを取得
  # @params project_id [Int]
  # @params completed  [Bool]
  #
  # @return Relation<Ticket>
  def self.get_tickets(project_id:, completed: false)
    tickets = Ticket.active
                    .where("project_id = ?", project_id)
                    .includes(:user)

    if completed
      tickets.completed
    else
      tickets.incomplete
    end
  end

end