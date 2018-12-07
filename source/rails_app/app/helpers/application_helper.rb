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

    if action.start_with?("new") || action.start_with?("create")
      t('text.action.create')
    elsif action.start_with?("edit") || action.start_with?("update")
      t('text.action.update')
    end
  end

  # webpackでbundleしたdiget付きjsファイルのincludeタグを生成
  # @params name [String] bundle名
  #
  # @return string
  def bundle_include_tag(name)
    target_file = Dir.glob("#{Rails.root}/public/dist/#{name}-*.bundle.js").sort_by{|f| File.mtime(f)}
                                                                           .reverse
                                                                           .map{|f| File.basename(f)}
                                                                           .first
    raw("<script src=\"/dist/#{target_file}\"></script>")
  end
end
