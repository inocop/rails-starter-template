module ApplicationHelper

  # 改行コードを<br />に変換
  # @params text [string]
  #
  # @return [string]
  def nl2br(text)
    raw(html_escape(text).gsub(/\r\n|\r|\n/, "<br />"))
  end

  # URLのリンク化と改行
  # @params text [string]
  #
  # @return [string]
  def auto_link_nl2br(text)
    raw(auto_link(nl2br(text)))
  end

  # action名から最適なボタンテキストを取得
  #
  # @return [string]
  def get_action_text
    action = controller.action_name

    if action == "new" || action == "create"
      t('text.action.create')
    elsif action == "edit" || action == "update"
      t('text.action.update')
    end
  end
end
