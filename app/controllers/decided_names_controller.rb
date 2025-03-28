class DecidedNamesController < ApplicationController
  def index
    @liked_names = DecidedName.liked(Current.user)
    @agreed_names = Name.agreed.order(:name)
  end

  def destroy
    DecidedName.find(params[:id]).update!(decision: false)
    redirect_to decided_names_path
  end
end
