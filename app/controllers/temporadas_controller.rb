#coding: utf-8
class TemporadasController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  def show
    if params[:serie_id]
      @temporada = Temporada.joins(:serie).where("series.slug = '#{params[:serie_id]}' and temporadas.temporada = #{params[:id]}" ).first
    else
      @temporada = Temporada.friendly.find(params[:id])
    end
    
    @title = @temporada.nome_temporada_formatado
    commontator_thread_show(@temporada)
  end
  
  def marcar_toda
    @temporada = Temporada.friendly.find(params[:id])
    serie = @temporada.serie
    serie.marcar_como_vista(current_user)
    @temporada.marcar_como_vista(current_user)
    respond_to do |format|
      format.html {redirect_to(action: "show", id: @temporada)}
      format.json { render json: @temporada, status: :ok }
    end
  end

  def desmarcar_toda
    @temporada = Temporada.friendly.find(params[:id])
    @temporada.desmarcar_como_vista(current_user)
    respond_to do |format|
      format.html {redirect_to(action: "show", id: @temporada)}
      format.json { render json: @temporada, status: :ok }
    end
  end
end