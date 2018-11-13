# ControllerとViewで共用するヘルパー
# これ以外のヘルパーはView専用とする。
module SharedWithControllerHelper

  # 現在選択しているproject_idを取得
  def current_project_id
    session[:current_project]
  end
end
