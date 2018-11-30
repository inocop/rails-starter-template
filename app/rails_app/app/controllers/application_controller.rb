class ApplicationController < ActionController::Base
  include SharedHelper

  protect_from_forgery with: :exception
  before_action :view_parts_initialize

  private
    # view_partsでjsやcssの二重ロード対策用の変数
    def view_parts_initialize
      @view_parts = {}
    end

    # [devise] ログアウト後、ログインページにリダイレクト
    # 「ログインしてください。」のメッセージを出さなくするため。
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
