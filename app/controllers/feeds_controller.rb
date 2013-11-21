class FeedsController < ApplicationController
  def index
    @series = Serie.all.order(:nome)

    respond_to do |format|
      format.html
      format.rss { render :layout => false } #index.rss.builder
    end
  end

  def episodios
    @episodios = Episodio.all.includes(:serie)

    respond_to do |format|
      format.html
      format.rss { render :layout => false } #episodios.rss.builder
    end

  end

  def temporadas
    @temporadas = Temporada.all.includes(:serie)

    respond_to do |format|
      format.html
      format.rss { render :layout => false } #temporadas.rss.builder
    end

  end

  def personagens
    @personagens = Personagem.all.includes(:serie)

    respond_to do |format|
      format.html
      format.rss { render :layout => false } #personagens.rss.builder
    end

  end

end
