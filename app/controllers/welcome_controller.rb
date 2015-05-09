require 'koala'
class WelcomeController < ApplicationController
	before_action :authenticate_user!
  def index
  	# raise current_user.inspect
    unless current_user.nil?
      @user = current_user
    else
      @user = nil
    end
    @graph = Koala::Facebook::API.new(@user.auth_token)
    myself = @graph.get_object('me')
  end
end
