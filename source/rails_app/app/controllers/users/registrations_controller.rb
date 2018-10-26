class Users::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters

  # @override
  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  private
    # 追加項目を許可
    def configure_permitted_parameters
      default_attrs = [ :email, :password, :password_confirmation ]
      added_attrs   = [ :user_image_path, :user_name ] | default_attrs

      devise_parameter_sanitizer.permit :sign_in,        keys: added_attrs
      devise_parameter_sanitizer.permit :sign_up,        keys: added_attrs
      #devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

end
