require "chromium_command"
require "puppeteer_command"

class Authed::Admin::TopController < AuthController
  layout "authed/admin/admin_base"

  before_action :authenticate_admin_user!

  def index
  end

  def create_pdf
    render(action: :index)
  end

  def create_png
    render(action: :index)
  end

  def node_call
    @text = PuppeteerCommand.hello_node(current_user.name)
    render(action: :index)
  end
end
