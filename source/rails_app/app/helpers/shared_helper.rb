# ControllerとViewで共用するヘルパー
# これ以外のヘルパーはView専用とする。
module SharedHelper

  # 現在選択しているproject_idを取得
  def current_project_id
    session[:current_project]
  end

  # ファイル名の文字化け対策
  # Rails6からは対応不要かも
  def filename_encoding(filename)
    if request.user_agent =~ /Windows/
      if (/MSIE/ =~ request.user_agent) || (/Trident/ =~ request.user_agent) || (/Edge/ =~ request.user_agent)
        filename = URI.encode(filename)
      end
    end

    filename
  end

end
