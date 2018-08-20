class AuthController < ApplicationController

  # checked login
  before_action :authenticate_user!

end