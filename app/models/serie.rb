#coding: utf-8
class Serie < ActiveRecord::Base
  extend FriendlyId

  friendly_id :nome, use: :slugged
  belongs_to :produtora
  has_many :avaliacoes, as: :avaliavel
  has_many :users, :through => :avaliacoes
  has_many :episodios, :dependent => :delete_all, :order => 'episodios.temporada,episodios.numero'
  has_many :personagens, :dependent => :delete_all, :order => 'personagens.aparicao'
  has_many :temporadas, :dependent => :delete_all
  has_many :episodios_vistos, :through => :avaliacoes, :source => :avaliavel, :source_type => "Episodio"
  has_and_belongs_to_many :generos

  def personagens_imagem
    self.personagens.where("imagem is not null");
  end

  def temporadas_validas_ordenadas(ordenacao="desc")
    self.temporadas.where("temporadas.temporada <> 0").order("temporadas.temporada #{ordenacao}")
  end

  def temporada_especial
    temporadas = self.temporadas.where("temporadas.temporada = 0")

    if (!temporadas.empty? && temporadas.size == 1)
      temporadas.first
    end
  end

  def media_geral
    self.avaliacoes.average('nota')
  end

  class << self

    def salvar(serie)
      nova_serie = copia_serie_api(serie)
      nova_serie.save
      inserir_temporadas(nova_serie)
      nova_serie
    end

    def inserir_temporadas(serie)
      temporada_banco = Episodio.find_by_sql("select temporada from episodios where serie_id=#{serie.id} group by temporada")

      for ep in temporada_banco

        existe = Temporada.find_by_sql("select * from temporadas where serie_id = #{serie.id} and temporada = #{ep.temporada}")

        if existe.size > 0
          temporada = existe.first
        else
          temporada = Temporada.new
        end

        temporada.serie = serie
        temporada.temporada = ep.temporada
        nome_imagem = "#{serie.id}-#{ep.temporada}.jpg"
        url = "http://thetvdb.com/banners/seasons/#{nome_imagem}"
        temporada.imagem = Serie.salvar_imagem(url, nome_imagem, "temporada")
        temporada.save
      end
    end


    def copia_serie_api(serie)
      nova_serie = Serie.friendly.find_by_id(serie.id)

      nova_serie ||= Serie.new

      nova_serie.id = serie.id
      nova_serie.nome = serie.series_name
      nova_serie.dia_exibicao = serie.airs_day_of_week
      nova_serie.horario_exibicao = serie.airs_time
      if serie.banner
        nova_serie.banner = Serie.salvar_imagem(serie.banner, serie.banner.split("/").last, "banner")
      else
        nova_serie.banner = "/images/series/imagem_padrao.jpg"
      end
      nova_serie.sinopse = serie.overview
      if serie.fanart
        nova_serie.fanart = Serie.salvar_imagem(serie.fanart, serie.fanart.split("/").last, "fanart")
      else
        nova_serie.fanart= "/images/series/imagem_padrao.jpg"
      end
      nova_serie.estreia = serie.first_aired
      nova_serie.id_imdb = serie.imdb_id

      if serie.poster
        nova_serie.poster = Serie.salvar_imagem(serie.poster, serie.poster.split("/").last, "serie")
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
          episodio = Episodio.new
          episodio.id = episodio_tvdb.id
          banco = Episodio.find_by_id(episodio_tvdb.id)
          if banco
            episodio = banco
          end
          episodio.numero = episodio_tvdb.episode_number
          episodio.nome = episodio_tvdb.episode_name
          episodio.temporada = episodio_tvdb.season_number
          episodio.diretor = episodio_tvdb.director
          episodio.escritores = episodio_tvdb.writer
          episodio.nota = episodio_tvdb.rating
          if episodio_tvdb.filename
            episodio.banner = Serie.salvar_imagem(episodio_tvdb.filename, episodio_tvdb.filename.split("/").last, "episodio")
          else
            episodio.banner = "/images/series/imagem_padrao.jpg"
          end

          episodio.id_imdb = episodio_tvdb.imdb_id
          episodio.sinopse = episodio_tvdb.overview
          episodio.atores_convidados = episodio_tvdb.guest_stars
          episodio.numero_absoluto = episodio_tvdb.absolute_number
          episodio.estreia = episodio_tvdb.first_aired

          if episodio.estreia
            if episodio.estreia.future?
              episodio.ativo = false
            else
              episodio.ativo = true
            end
          end

          episodio.serie= serie
          serie.episodios<< episodio
        end
      end
    end

    def updater_bot(tempo=1.day.ago)

      tvdb = Tvdbr::Client.new
      tvdb.each_updated_series(:since => tempo) do |serie|
        Serie.salvar(serie)
      end
    end

    def update_serie(serie)
      tvdb = Tvdbr::Client.new
      serie_by_id = tvdb.find_series_by_id(serie.id)
      if serie_by_id
        serie_banco = Serie.salvar serie_by_id
      end
    end

    #
    #Baixa a imagem da url passada, passando tbm o nome do arquivo
    #e retorna o caminho do disco
    #
    def salvar_imagem(url, nome_imagem, tipo="temporada")
      pasta_base = "app/assets/images/series/"
      if tipo.eql? "temporada"
        pasta = "season/"
        caminho_disco = "#{pasta_base}#{pasta}"
      end
      if tipo.eql? "personagem"
        pasta = "elenco/"
        caminho_disco = "#{pasta_base}#{pasta}"
      end
      if tipo.eql? "serie"
        pasta = "poster/"
        caminho_disco = "#{pasta_base}#{pasta}"
      end
      if tipo.eql? "banner"
        pasta = "banner/"
        caminho_disco = "#{pasta_base}#{pasta}"
      end
      if tipo.eql? "episodio"
        pasta = "episodio/"
        caminho_disco = "#{pasta_base}#{pasta}"
      end
      if tipo.eql? "fanart"
        pasta = "fanart/"
        caminho_disco = "#{pasta_base}#{pasta}"
      end
      if tipo.eql? "pesquisa"
        pasta = "pesquisa/"
        caminho_disco = "#{pasta_base}#{pasta}"
      end

      begin
        File.open("#{caminho_disco}#{nome_imagem}", "wb") do |file|
          file.write open(url).read
        end
      rescue
        return "/images/series/imagem_padrao.jpg"
      end
      "/images/series/#{pasta}#{nome_imagem}"
    end
  end

  def marcar_como_vista(user, finalizou=false, nota=nil)
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Serie' and avaliavel_id=#{self.id} and user_id=#{user.id} ")
    if aval.empty?
      aval = Avaliacao.new
      aval.user = user
      if nota
        aval.nota= nota
      end
      acompanhamento = criar_acompanhamento(aval, finalizou)
      self.avaliacoes << aval
      self.save
    else
      aval_banco = aval.first
      if self.finalizada? && finalizou
        if !aval_banco.acompanhamento_serie.finalizada
          aval_banco.acompanhamento_serie.finalizada = true
          aval_banco.acompanhamento_serie.ativa = false
          aval_banco.acompanhamento_serie.geladeira = false
          aval_banco.acompanhamento_serie.abandonada = false
          aval_banco.acompanhamento_serie.save
        end
      end
      if nota
        aval_banco.nota = nota
        aval_banco.save
      end
    end
  end

  def desmarcar_como_vista(user)
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Serie' and avaliavel_id=#{self.id} and user_id=#{user.id} ")
    if !aval.empty?
      aval.first.destroy
    end
  end

  def criar_acompanhamento(aval, finalizou)
    acompanhamento= AcompanhamentoSerie.new
    if finalizou
      if self.finalizada?
        acompanhamento.finalizada = true
        acompanhamento.ativa = false
        acompanhamento.geladeira = false
        acompanhamento.abandonada = false
      else
        acompanhamento.ativa = true
        acompanhamento.finalizada = false
        acompanhamento.geladeira = false
        acompanhamento.abandonada = false
      end
    else
      acompanhamento.ativa = true
      acompanhamento.finalizada = false
      acompanhamento.geladeira = false
      acompanhamento.abandonada = false
    end
    acompanhamento.avaliacao = aval
    aval.acompanhamento_serie = acompanhamento
  end

  def marcar_inteira(user)
    self.marcar_como_vista(user, true)
    self.temporadas_validas_ordenadas("asc").each do |temporada|
      temporada.marcar_como_vista(user)
    end
  end

  def finalizada?
    self.status.eql? "Finalizada"
  end

  def episodios_exibicao
    result = self.episodios.where("temporada <> 0 and estreia <  '#{Time.now}' ").order("temporada desc, numero desc")
    if result.size == 0
      result = self.episodios.where("temporada <> 0 and (estreia <  '#{Time.now}' or estreia is null )").order("temporada desc, numero desc")
    end
    return result
  end

  def visualizacoes_semanais(nota_null = "")
    series = Serie.find_by_sql("select * from series s, episodios e, avaliacoes a where e.serie_id = s.id and e.id = a.avaliavel_id and a.created_at > '#{1.week.ago}' and s.id = #{self.id} and a.avaliavel_type= 'Episodio' #{nota_null} order by a.created_at desc ")
  end

  def votos_semanais
    self.visualizacoes_semanais(" and a.nota is not null")
  end

  def data_lancamento
    temporada_um = temporadas.where(:temporada => 1)
    if temporada_um
      temporada_um.first.data_lancamento
    end
  end

  def nota_user(user=nil)
    if user
      aval_user = self.avaliacoes.where(user: user)
      if !aval_user.empty?
        aval_user.first.nota
      end
    end
  end

end
