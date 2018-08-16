class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  # deviseが自動でやってくれるので不要っぽい

  # [devise] ログアウト後、ログインページにリダイレクト
  # def after_sign_out_path_for(resource_or_scope)
  #   user_session_path
  # end

  # # [devise] ログイン認証前にアクセスしようとしたURLがあればリダイレクト
  # def after_sign_in_path_for(resource_or_scope)
  #   if (session[:user_return_to] == root_path)
  #     super
  #   else
  #     session[:user_return_to] || root_path
  #   end
  # end

end
