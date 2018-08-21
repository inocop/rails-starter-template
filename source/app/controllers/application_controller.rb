class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  # [devise] ログアウト後、ログインページにリダイレクト
  def after_sign_out_path_for(resource_or_scope)
    user_session_path
  end

  # # deviseが自動でやってくれるっぽいのでコメントアウト
  # # [devise] フレンドリーフォワーディング（ログイン前にアクセスしようとしたURLにリダイレクト）
  # def after_sign_in_path_for(resource_or_scope)
  #   if (session[:user_return_to] == root_path)
  #     super
  #   else
  #     session[:user_return_to] || root_path
  #   end
  # end

end
