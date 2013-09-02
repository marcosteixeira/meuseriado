#coding: utf-8
class TemporadasController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  def show
    if params[:serie_id]
      @temporada = Temporada.joins(:serie).where("series.slug = '#{params[:serie_id]}' and temporadas.temporada = #{params[:id]}" ).first
    else
      @temporada = Temporada.friendly.find(params[:id])
    end
    
    @title = "#{@temporada.serie.nome} - Temporada #{@temporada.temporada}"
  end
  
  def marcar_toda
    @temporada = Temporada.friendly.find(params[:id])
    serie = @temporada.serie
    serie.marcar_como_vista(current_user)
    @temporada.marcar_como_vista(current_user)
    redirect_to(action: "show", id: @temporada)
  end
end