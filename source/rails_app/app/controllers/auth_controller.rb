class AuthController < ApplicationController
  layout 'application_base'

  # checked login
  before_action :authenticate_user!
  before_action :check_current_project_id

  private
    # adminユーザでなければroot_pathへリダイレクト
    def authenticate_admin_user!
      unless current_user.admin
        redirect_to root_path
      end
    end

    # プロジェクト一覧を取得し、
    # 選択プロジェクトが無ければリストの先頭を選択
    def check_current_project_id
      @select_projects = Project.all

      if current_project_id.blank?
        session[:current_project] = @select_projects.first&.id
      end
    end
end