class TopController < ApplicationController

  # checked csrf token
  protect_from_forgery with: :exception
  # checked login
  before_action :authenticate_user!

  def index
  end
end
