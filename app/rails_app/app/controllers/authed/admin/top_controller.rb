class Authed::Admin::TopController < AuthController
  layout "authed/admin/admin_base"

  before_action :authenticate_admin_user!

  def index
  end

end
