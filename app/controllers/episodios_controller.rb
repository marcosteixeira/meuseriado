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
    
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Episodio' and avaliavel_id=#{@episodio.id} and user_id=#{current_user.id} ")

    if aval.empty? 
      aval = Avaliacao.new
      aval.user = current_user
      @episodio.avaliacoes << aval
      @episodio.save
    end 
    redirect_to(action: "show", id: @episodio)
  end
  
end
