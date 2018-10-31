class Authed::ProfileController < AuthController
  layout 'authed/profile'

  def index
    redirect_to action: :edit
  end

  def edit
  end

  def update
    if current_user.update(profile_params)
      flash[:notice] = 'Profile was successfully updated.'
      redirect_to action: :edit
    else
      flash.now[:alert] = current_user.errors.full_messages.join("\n")
      render :edit
    end
  end

  # ユーザーアイコン編集
  # GET /users/profile/edit_images
  def edit_image
  end

  # ユーザーアイコン更新
  # POST /users/profile/edit_images
  def update_image
    if current_user.update(profile_image_params)
      flash[:notice] = 'Profile image was successfully updated.'
      redirect_to action: :edit_image
    else
      flash.now[:alert] = current_user.errors.full_messages.join("\n")
      render :edit_image
    end
  end

  def edit_password
  end

  def update_password
  end

  private
    def profile_params
      params.require(:user)
            .permit(:user_name, :email)
    end

    def profile_image_params
      params.require(:user)
            .permit(:user_image_path)
    end

    def profile_password_params
      params.require(:user)
            .permit(:user_password)
    end
end
