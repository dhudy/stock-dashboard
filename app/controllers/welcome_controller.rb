class WelcomeController < ApplicationController
  def index
    unless current_user.nil?
      @user = current_user
    else
      @user = nil
    end
  end
end
