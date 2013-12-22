#coding: utf-8
class EpisodiosController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @episodios||= Episodio.order(:nome)
  end

  def show
    @episodio = Episodio.friendly.find(params[:id])
    @title = "#{@episodio.nome_episodio_formatado} - Temporada #{@episodio.temporada} Episódio #{@episodio.numero} - #{@episodio.nome}"
    commontator_thread_show(@episodio)
    @og_image = "http://meuseriado.com.br#{@episodio.banner}"

  end

  def marcar
    @episodio = Episodio.friendly.find(params[:id])
    serie = @episodio.serie
    serie.marcar_como_vista(current_user)
    @episodio.marcar_como_visto(current_user)

    respond_to do |format|
      format.html { redirect_to(action: "show", id: @episodio) }
      format.json { render json: @episodio.to_json({:include => {:serie => {:methods => [:slug, :percentual_conclusao_temporada]}, :proximo => {:methods => [:nome_episodio, :percentual_conclusao_temporada]}}, :methods => [:nome_episodio, :percentual_conclusao_temporada]}), status: :ok }
    end
  end

  def desmarcar
    @episodio = Episodio.friendly.find(params[:id])
    @episodio.desmarcar_como_visto(current_user)

    respond_to do |format|
      format.html { redirect_to(action: "show", id: @episodio) }
      format.json { render json: @episodio, status: :ok }
    end
  end

  def dar_nota
    @episodio = Episodio.friendly.find(params[:id])
    nota = params[:nota]
    if nota
      @episodio.marcar_como_visto(current_user, nota)
    end
    redirect_to(action: "show", id: @episodio)
  end

end
