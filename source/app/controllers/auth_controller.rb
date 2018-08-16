class AuthController < ApplicationController
  layout "app_base"

  # checked login
  before_action :authenticate_user!

end