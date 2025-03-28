class NamesController < ApplicationController
  def index
    @name = Name.i_havent_seen_yet(Current.user).random
  end

  def vote
    name = Name.find(params[:id])
    DecidedName.create(user: Current.user, name: name, decision: params[:decision] == "yes")
    redirect_to names_path
  end
end
