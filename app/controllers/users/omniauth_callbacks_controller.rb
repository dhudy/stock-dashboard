class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  require 'koala'
  def facebook
    puts "--#{request.env['omniauth.auth'].inspect}"
    @user = User.from_omniauth(request.env['omniauth.auth'])
    @user.auth_token = request.env['omniauth.auth']['credentials']['token']
    @graph = Koala::Facebook::API.new(@user.auth_token)
    myself = @graph.get_object("me")
    @user.fb_id = myself['id']
    @user.save
    if @user.persisted?
      sign_in @user
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      redirect_to welcome_path
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
