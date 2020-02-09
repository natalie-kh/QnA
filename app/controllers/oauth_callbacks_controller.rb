class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_via_oauth

  def github; end

  def facebook; end

  private

  def sign_in_via_oauth
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: auth.provider.capitalize)
      end

    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
