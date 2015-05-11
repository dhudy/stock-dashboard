class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_comments

  def set_comments
  	@comments = Comment.order('created_at DESC')
  	@counter = 0
  end
end
