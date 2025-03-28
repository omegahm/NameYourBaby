class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: "Kodeordet er oprettet."
    else
      redirect_to edit_password_path(params[:token]), alert: "Kodeorderne var ikke ens."
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to root_path, alert: "Kodeords linket er ikke længere gyldigt."
    end
end
