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

    # 担当プロジェクトか確認。
    # nil or 担当外プロジェクトの場合、先頭をcurrent_project_idとする。
    def check_current_project_id
      @assign_projects = Project.active

      if current_project_id.blank? || !@assign_projects.ids.include?(current_project_id)
        select_project_id(@assign_projects.first.try!(:id))
      end
    end

    # 選択project_idを設定
    def select_project_id(project_id)
      session[:current_project] = project_id
    end
end