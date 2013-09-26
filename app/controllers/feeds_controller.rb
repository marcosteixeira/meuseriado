class FeedsController < ApplicationController
  def index
    @series = Serie.all.order(:nome)
    @episodios = Episodio.all.joins(:serie).order('series.nome, temporada, numero')
    @temporadas = Temporada.all.joins(:serie).order('series.nome, temporada')
    @personagens = Personagem.all

    respond_to do |format|
      format.html
      format.rss { render :layout => false } #index.rss.builder
    end
  end
end
