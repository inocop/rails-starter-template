class Authed::ProfileController < AuthController
  layout 'authed/profile'

  def index
    redirect_to(action: :edit)
  end

  def edit
  end

  def update
    if current_user.update(profile_params)
      flash[:notice] = t('.success_message')
      redirect_to(action: :edit) and return
    else
      flash.now[:alert] = current_user.errors.full_messages.join("\n")
      render(:edit)
    end
  end

  # ユーザーアイコン編集
  # GET /profile/edit_images
  def edit_image
  end

  # ユーザーアイコン更新
  # POST /profile/edit_images
  def update_image
    if current_user.update(profile_image_params)
      flash[:notice] = t('.success_message')
      redirect_to(action: :edit_image) and return
    else
      flash.now[:alert] = current_user.errors.full_messages.join("\n")
      render(:edit_image)
    end
  end

  # パスワード編集
  # GET /profile/edit_password
  def edit_password
  end

  # パスワード変更
  # POST /profile/edit_password
  def update_password
    if current_user.update_with_password(profile_password_params)
      bypass_sign_in(current_user)
      flash[:notice] = t('.success_message')
      redirect_to(action: :edit_password) and return
    else
      render(:edit_password)
    end
  end

  private
    def profile_params
      params.require(:user).permit(:name, :email)
    end

    def profile_image_params
      params.require(:user).permit(:image)
    end

    def profile_password_params
      params.require(:user).permit(:current_password,
                                   :password,
                                   :password_confirmation)
    end
end
