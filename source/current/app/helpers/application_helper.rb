module ApplicationHelper

  # 改行コードを<br />に変換
  # @params text [string]
  #
  # @return [string]
  def nl2br(text) 
    raw(html_escape(text).gsub(/\r\n|\r|\n/, "<br />"))
  end
end
