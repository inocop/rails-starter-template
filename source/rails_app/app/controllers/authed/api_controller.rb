# 画面を持たない処理用のクラス
class Authed::ApiController < AuthController
  layout false

  # POST /api/select_project
  # プロジェクト切り替え
  def select_project
    project_id = params[:project_id]
    controller = params[:controller_name] || root_path

    unless project_id.nil?
      session[:current_project] = project_id.to_i
      redirect_to(:controller => controller, :action => 'index')
    else
      raise 'project_id is nil'
    end
  end

end