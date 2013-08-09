#coding: utf-8
class SeriesController < ApplicationController

  def my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/series.log")
  end
  
  require 'open-uri'  
  def index
  
    if params['id_serie_search']
      buscar_series
    end
    
    @series||= Serie.order(:nome)
    @iniciais = cria_array_iniciais(@series)
  end
  
  def cria_array_iniciais(series)
    array = Array.new
    series.each do |serie|
      if !array.include? serie.nome[0,1] 
        array << serie.nome[0,1]
      end
    end
    array
  end
  
  def create
      buscar_series 
  end
  
  def buscar_series(nome_serie=nil)
    my_logger.info("Iniciando criação de série")    
    nome_serie||= params['pesquisa']
    id_serie = params['id_serie_search']
    
    my_logger.info("ID: #{id_serie}, Nome: #{nome_serie}")    
          
    if (nome_serie.nil? || nome_serie.blank?) && (id_serie.nil? || id_serie.blank? ) 
        my_logger.info("Todas as informações estão vazias")    
      redirect_to action: 'index'
    else
        series=[]
        if id_serie
          serie_banco = Serie.find_by_id(id_serie)
          my_logger.info("Id série informado")
          if serie_banco
          my_logger.info("Serie ja existe banco")
              redirect_to(action: "show", id: serie_banco)
          else 
              my_logger.info("Serie nao existe, buscando série na api")
              tvdb = Tvdbr::Client.new
              serie_by_id = tvdb.find_series_by_id(id_serie.to_i)
              my_logger.info("Salvando série no banco")
              serie_banco = salvar serie_by_id
              my_logger.info("Redirecionando para show")
              redirect_to(action: "show", id: serie_banco)
          end
        else
            my_logger.info("Passou nome serie, buscando série no banco" )
            serie_banco = Serie.find_by_nome(nome_serie)
            if serie_banco
                my_logger.info("Serie ja existe")
                redirect_to(action: "show", id: serie_banco)
            else
                  my_logger.info("Serie nao existe buscando na api" )
                  tvdb = Tvdbr::Client.new
                  series = tvdb.fetch_series_from_data(:title => nome_serie)
                  if series.empty?
                    flash[:notice] = "Nenhuma série encontrada com esse nome."
                    redirect_to action: 'index'
                  else
                        if (series.first.series_name.downcase.eql? nome_serie.downcase || series.size == 1)
                            my_logger.info("SERIE UNICA, SALVANDO SERIE")
                            serie_banco = salvar series.first
                            my_logger.info("REDIRECIONANDO PARA SHOW")
                            redirect_to(action: "show", id: serie_banco)
                        else
                             @series= []
                             for s in series
                                   if series.size <= 3
                                    my_logger.info("retornou mais de 3 resultados")
                                    serie_pesquisa = salvar s
                                    params['search'] = false
                                   else
                                     if s 
                                        my_logger.info("retornou menos de 3 resultados")
                                        serie_pesquisa = Serie.new
                                        serie_pesquisa.nome = s.series_name
                                        serie_pesquisa.id = s.id
                                        serie_pesquisa.nota = s.rating
                                            if s.poster
                                              serie_pesquisa.poster = Serie.salvar_imagem(s.poster,s.poster.split("/").last , "pesquisa")
                                            else
                                              serie_pesquisa.poster = "/images/series/imagem_padrao.jpg"  
                                            end
                                        params['search'] = true
                                      end
                                   end
                                   @series << serie_pesquisa
                                   @iniciais = cria_array_iniciais(@series)
                             end
                             render action: "index"
                        end
                  end
            end
        end
    end
  end

  def show
    if params[:id].to_i == 0
      @serie = Serie.friendly.find_by_slug(params[:id])
    else
      @serie = Serie.friendly.find_by_id(params[:id])
    end
    if !@serie
    
      tvdb = Tvdbr::Client.new    
      if params[:id].to_i == 0
    
        params[:id_serie] = nil
        buscar_series params[:id]
      else
        @serie = salvar(tvdb.find_series_by_id(params[:id]))
        redirect_to(action: "show", id: @serie)
      end
    end

    @title = @serie.nome
  end
  
  def salvar(serie)
    nova_serie = copia_serie_api(serie)
    nova_serie.save
    inserir_temporadas(nova_serie)
    nova_serie
  end
  
  def copia_serie_api(serie)
    nova_serie = Serie.friendly.find_by_id(serie.id)
    
    nova_serie ||= Serie.new
    
    nova_serie.id = serie.id
    nova_serie.nome = serie.series_name
    nova_serie.dia_exibicao = serie.airs_day_of_week
    nova_serie.horario_exibicao = serie.airs_time
    if serie.banner
      nova_serie.banner = Serie.salvar_imagem(serie.banner,serie.banner.split("/").last , "banner")
    else
      nova_serie.banner = "/images/series/imagem_padrao.jpg"  
    end
    nova_serie.sinopse = serie.overview
    if serie.fanart 
      nova_serie.fanart = Serie.salvar_imagem(serie.fanart,serie.fanart.split("/").last , "fanart")
    else
      nova_serie.fanart= "/images/series/imagem_padrao.jpg"    
    end
    nova_serie.estreia = serie.first_aired
    nova_serie.id_imdb = serie.imdb_id
    
    if serie.poster 
      nova_serie.poster = Serie.salvar_imagem(serie.poster,serie.poster.split("/").last , "serie")
    else
      nova_serie.poster = "/images/series/imagem_padrao.jpg"
    end
    nova_serie.nota = serie.rating
    nova_serie.duracao_episodio = serie.runtime
    if serie.network
      nova_serie.produtora = Produtora.find_or_create_by(nome: serie.network)
    end
    
    
    if serie.status.eql? "Ended"
      nova_serie.status = "Finalizada"
    else
      nova_serie.status = "Em andamento"
    end
    
    copia_episodios(serie, nova_serie)
    copia_personagens(serie, nova_serie)
    copia_generos(serie.categories, nova_serie)
    nova_serie
  end
  
  def copia_generos(generos, nova_serie)
    generos.each do |genero|
      nova_serie.generos << Genero.find_or_create_by(nome: genero)
    end
  end
  
  def copia_personagens(serie_tvdb, serie)
    for personagem_tvdb in serie_tvdb.actors_serie
      if !personagem_tvdb.nil?
        personagem_tvdb.serie = serie
        serie.personagens << personagem_tvdb
      end
    end
  end
  
  def copia_episodios(serie_tvdb, serie)
    serie_tvdb.episodes.each do |episodio_tvdb|
      if episodio_tvdb.episode_name
        #episodio = Episodio.find_by_sql("select id from episodios where id = #{episodio_tvdb.id}")
        #if episodio.blank?
         # episodio = Episodio.new
        #else
         # episodio = Episodio.find(episodio.first.id)
        #end
        episodio = Episodio.new
        episodio.id = episodio_tvdb.id
        episodio.numero = episodio_tvdb.episode_number
        episodio.nome = episodio_tvdb.episode_name
        episodio.temporada = episodio_tvdb.season_number
        episodio.diretor = episodio_tvdb.director
        episodio.escritores = episodio_tvdb.writer
        episodio.nota = episodio_tvdb.rating
        if episodio_tvdb.filename
          episodio.banner = Serie.salvar_imagem(episodio_tvdb.filename,episodio_tvdb.filename.split("/").last , "episodio")
        else
          episodio.banner = "/images/series/imagem_padrao.jpg"
        end
             
        episodio.id_imdb = episodio_tvdb.imdb_id
        episodio.sinopse = episodio_tvdb.overview
        episodio.atores_convidados = episodio_tvdb.guest_stars
        episodio.numero_absoluto = episodio_tvdb.absolute_number
        episodio.estreia = episodio_tvdb.first_aired
        episodio.serie= serie
        serie.episodios<< episodio
      end
    end
  end
  
  def inserir_temporadas(serie)
    episodios = Episodio.find_by_sql("select temporada from episodios where serie_id='#{serie.id}' group by temporada")
    
    for ep in episodios
      temporada = Temporada.new
      temporada.serie = serie
      temporada.temporada = ep.temporada
      nome_imagem = "#{serie.id}-#{ep.temporada}.jpg"
      url = "http://thetvdb.com/banners/seasons/#{nome_imagem}"
      temporada.imagem = Serie.salvar_imagem(url, nome_imagem, "temporada")
      temporada.save
    end
  end
  
end
