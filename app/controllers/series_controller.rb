#coding: utf-8
class SeriesController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index, :my_logger, :create, :carregar_series, :personagens]

  def my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/series.log")
  end

  require 'open-uri'

  def index
    if params['id_serie_search']
      buscar_series
    end
    session[:pagina_pesquisa_atual] = 1
  end

  # @return [json]
  def carregar_series
    @series||= Serie.order(:nome).page(session[:pagina_pesquisa_atual]).per(20)
    @iniciais = cria_array_iniciais(@series)
    session[:pagina_pesquisa_atual] = session[:pagina_pesquisa_atual] + 1
    render :json => {:status => :ok, :series => @series.as_json}
  end

  def cria_array_iniciais(series)
    array = Array.new
    series.each do |serie|
      if !array.include? serie.nome[0, 1]
        array << serie.nome[0, 1]
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

    if (nome_serie.nil? || nome_serie.blank?) && (id_serie.nil? || id_serie.blank?)
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
          if serie_by_id
            my_logger.info("Salvando série no banco")
            serie_banco = Serie.salvar serie_by_id
            my_logger.info("Redirecionando para show")
            redirect_to(action: "show", id: serie_banco)
          else
            my_logger.info("Serie nao encontrada mediante id passado")
            flash[:notice] = "Nenhuma série encontrada."
            redirect_to action: 'index'
          end
        end
      else
        my_logger.info("Passou nome serie, buscando série no banco")
        serie_banco = Serie.find_by_nome(nome_serie)
        if serie_banco
          my_logger.info("Serie ja existe")
          redirect_to(action: "show", id: serie_banco)
        else
          my_logger.info("Serie nao existe buscando na api")
          tvdb = Tvdbr::Client.new
          series = tvdb.fetch_series_from_data(:title => nome_serie)
          if series.empty?
            flash[:notice] = "Nenhuma série encontrada com esse nome."
            redirect_to action: 'index'
          else
            if (series.first.series_name.downcase.eql? nome_serie.downcase || series.size == 1)
              my_logger.info("SERIE UNICA, SALVANDO SERIE")
              serie_banco = Serie.salvar series.first
              my_logger.info("REDIRECIONANDO PARA SHOW")
              redirect_to(action: "show", id: serie_banco)
            else
              @series= []
              for s in series
                if series.size <= 3
                  my_logger.info("retornou menos de 3 resultados")
                  serie_pesquisa = Serie.salvar s
                  params['search'] = true
                else
                  if s
                    my_logger.info("retornou mais de 3 resultados")
                    serie_pesquisa = Serie.new
                    serie_pesquisa.nome = s.series_name
                    serie_pesquisa.id = s.id
                    serie_pesquisa.nota = s.rating
                    if s.poster
                      serie_pesquisa.poster = Serie.salvar_imagem(s.poster, s.poster.split("/").last, "pesquisa")
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
    if params[:id].respond_to?(:to_str)
      @serie = Serie.friendly.find_by_slug(params[:id])
    else
      @serie = Serie.friendly.find_by_id(params[:id])
    end
    if !@serie

      tvdb = Tvdbr::Client.new
      if params[:id].respond_to?(:to_str)

        params[:id_serie] = nil
        buscar_series params[:id]
      else
        @serie = Serie.salvar(tvdb.find_series_by_id(params[:id]))
        redirect_to(action: "show", id: @serie)
      end
    end

    @title = @serie.nome
    commontator_thread_show(@serie)
  end

  def adicionar
    @serie = Serie.friendly.find(params[:id])
    @serie.marcar_como_vista(current_user)
    redirect_to(action: "show", id: @serie)
  end

  def desmarcar
    @serie = Serie.friendly.find(params[:id])
    @serie.desmarcar_como_vista(current_user)
    redirect_to(action: "show", id: @serie)
  end

  def marcar_toda
    @serie = Serie.friendly.find(params[:id])
    @serie.marcar_inteira(current_user)
    redirect_to(action: "show", id: @serie)
  end

  def inserir_trailer

    if current_user.admin?
      @serie = Serie.friendly.find(params[:id])
      @serie.trailer = params['trailer']
      @serie.save!
    end
    redirect_to(action: "show", id: @serie)
  end

end
