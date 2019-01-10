class Authed::DashboardController < AuthController
  layout 'authed/dashboard'

  def index
    # ユーザー一覧
    users = User.all
    # ステータス別にticketを分割
    tickets = Ticket.where("project_id = ?", current_project_id)

    @user_list = []
    @draft_list = []
    @start_list = []
    users.each do |user|
      @user_list  << user.name
      @draft_list << tickets.select{|item| user.id == item.assigned_user_id && item.status == TicketConst::STATUS_DRAFT}.count
      @start_list << tickets.select{|item| user.id == item.assigned_user_id && item.status == TicketConst::STATUS_START}.count
    end
  end

end
