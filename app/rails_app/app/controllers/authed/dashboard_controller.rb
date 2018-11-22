class Authed::DashboardController < AuthController
  layout 'authed/dashboard'

  def index
    projects = Project.active
    tickets = Ticket.active

    @project_list = []
    @draft_ticket_list = []
    @start_ticket_list = []
    @end_ticket_list   = []
    projects.each do |project|
      @project_list << project.name
      @draft_ticket_list << tickets.select{|item| project.id == item.project_id && item.status == Ticket::STATUS_DRAFT}.count
      @start_ticket_list << tickets.select{|item| project.id == item.project_id && item.status == Ticket::STATUS_START}.count
      @end_ticket_list   << tickets.select{|item| project.id == item.project_id && item.status == Ticket::STATUS_END}.count
    end

  end

end
