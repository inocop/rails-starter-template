class Admin::TopController < AuthController
  layout "admin/admin_base"

  before_action :authenticate_admin_user!

  def index
  end

end
