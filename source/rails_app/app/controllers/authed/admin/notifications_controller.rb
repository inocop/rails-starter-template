class Authed::Admin::NotificationsController < AuthController
  layout "authed/admin/admin_base"

  before_action :set_notification, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin_user!
  
  # GET /authed/admin/notifications
  # GET /authed/admin/notifications.json
  def index
    @notifications = {}
  end

  # GET /authed/admin/notifications/1
  # GET /authed/admin/notifications/1.json
  def show
  end

  # GET /authed/admin/notifications/new
  def new
  end

  # POST /authed/admin/notifications
  # POST /authed/admin/notifications.json
  def create
    NotificationDeliverJob.perform_later
    redirect_to(action: :index, notice: 'Send notification.') and return
  end

  # DELETE /authed/admin/notifications/1
  # DELETE /authed/admin/notifications/1.json
  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = ""
      #@notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.fetch(:notification, {})
    end
end
