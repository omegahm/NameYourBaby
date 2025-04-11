class NamesController < ApplicationController
  def index
    @name = Name.i_havent_seen_yet(Current.user).random
  end

  def vote
    name = Name.find(params[:id])
    DecidedName.create(user: Current.user, name: name, decision: params[:decision] == "yes")

    respond_to do |format|
      format.turbo_stream do
        @name = Name.i_havent_seen_yet(Current.user).random
      end

      format.html { redirect_to names_path }
    end
  end
end
