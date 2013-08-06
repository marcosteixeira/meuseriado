#coding: utf-8
class TemporadasController < ApplicationController
  def show
    @temporada = Temporada.joins(:serie).where("series.slug = '#{params[:serie_id]}' and temporadas.temporada = #{params[:id]}" ).first
  end
end