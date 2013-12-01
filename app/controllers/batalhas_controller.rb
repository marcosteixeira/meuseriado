class BatalhasController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def show
    @batalha = Batalha.friendly.find(params[:id])
    commontator_thread_show(@batalha)
  end

  def votar_neutro
    @batalha = Batalha.friendly.find(params[:id])
    current_user.votar(@batalha, @batalha.desafiante, true)
    redirect_to(action: "show", id: @batalha)
  end

end
