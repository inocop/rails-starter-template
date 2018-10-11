class Users::ProfileController < AuthController

  def edit
    @user = User.find_by_id(current_user.id)
  end

  def update
    @user = User.find_by_id(current_user.id)
    
    if @user.update(profile_params)
      flash[:notice] = 'Profile was successfully updated.'
      redirect_to action: :edit
    else
      flash.now[:alert] = @user.errors.full_messages.join("\n")
      render :edit
    end
  end

  def edit_password
  end

  def update_password
  end

  private
  def profile_params
    params.require(:user)
          .permit(:user_name, :email, :user_image_path)
  end
end
