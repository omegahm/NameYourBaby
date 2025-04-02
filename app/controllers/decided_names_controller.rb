class DecidedNamesController < ApplicationController
  def index
    @agreed_names = Name.agreed.order(:name).to_a
    @liked_names = DecidedName.includes(:name).liked(Current.user).to_a
  end

  def destroy
    DecidedName.find(params[:id]).update!(decision: false)
    redirect_to decided_names_path
  end
end
