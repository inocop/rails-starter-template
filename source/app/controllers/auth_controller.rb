class AuthController < ApplicationController

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
        current_project_id = @select_projects.first&.id
      end
    end

    # 現在選択しているproject_idを取得
    # viewからも呼べるようにhelper_methodとして登録
    def current_project_id
      session[:current_project]
    end
    helper_method :current_project_id
end