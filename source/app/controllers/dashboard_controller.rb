class DashboardController < AuthController
  layout "dashboard"

  def index
    # ユーザー一覧
    users = User.all
    # ステータス別にticketを分割
    tickets = Ticket.where("project_id = ?", current_project_id)

    @email_list = []
    @draft_date_list = []
    @start_date_list = []
    @end_date_list   = []
    users.each do |user|
      @email_list << user.email
      @draft_date_list << tickets.select{|item| user.id == item.assigned_user_id && item.status == Ticket::STATUS_DRAFT}.count
      @start_date_list << tickets.select{|item| user.id == item.assigned_user_id && item.status == Ticket::STATUS_START}.count
      @end_date_list   << tickets.select{|item| user.id == item.assigned_user_id && item.status == Ticket::STATUS_END}.count
    end

  end

end
