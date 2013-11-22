class BatalhasController < ApplicationController
  def show
    @batalha = Batalha.friendly.find(params[:id])
    commontator_thread_show(@batalha)
  end
end
