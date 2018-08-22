class Admin::TopController < AuthController
  layout "admin"

  before_action :authenticate_admin_user!

  def index
  end

end
