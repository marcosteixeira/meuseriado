#coding: utf-8
class EpisodiosController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show, :index]
  
  def index
    @episodios||= Episodio.order(:nome)
  end

  def show
    @episodio = Episodio.friendly.find(params[:id])
    @title = "#{@episodio.nome_episodio_formatado} - Temporada #{@episodio.temporada} Episódio #{@episodio.numero} - #{@episodio.nome}"
  end

  def marcar
    @episodio = Episodio.friendly.find(params[:id])
    serie = @episodio.serie
    serie.marcar_como_vista(current_user)
    @episodio.marcar_como_visto(current_user)
    redirect_to(action: "show", id: @episodio)
  end
  
end
