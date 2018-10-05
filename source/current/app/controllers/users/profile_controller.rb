class Users::ProfileController < AuthController
  layout 'application_base'

  def edit
    @user = User.find_by_id(current_user.id)
  end

  def update
  end


  def edit_password
  end

  def update_password
  end

end
