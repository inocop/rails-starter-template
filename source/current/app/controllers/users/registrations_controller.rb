class Users::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters

  private
    def configure_permitted_parameters
      added_attrs = [ :user_name, :email, :password, :password_confirmation　]

      devise_parameter_sanitizer.permit :sign_in,        keys: added_attrs
      devise_parameter_sanitizer.permit :sign_up,        keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

end
