class CommentsController < ApplicationController
  def new
  end

  def create
  	if current_user
  		comment = current_user.comments.build(body: params[:body])
  		if comment.save
  			flash[:success] = "Your message was posted!"
  		else
  			flash[:error] = "Your message could not be sent, please try again later."
  		end
  	end
  	redirect_to :back
  end
end
