require 'koala'
class WelcomeController < ApplicationController
	# before_action :authenticate_user!
  def index
  	# raise current_user.inspect
    unless current_user.nil?
      @user = current_user
      @graph = Koala::Facebook::API.new(@user.auth_token)
      @posts = @graph.get_connection('me', 'home',
                    {limit: 25,
                      fields: ['message', 'id', 'from', 'type',
                                'picture', 'link', 'created_time', 'updated_time'
                        ]})
      # raise @posts.inspect
	  myself = @graph.get_object('me')
	  # raise myself.inspect

	  if params['lookup']

	  end
    else
      @user = nil
    end
  end
end
