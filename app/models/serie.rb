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
  has_and_belongs_to_many :generos
  
  def personagens_imagem
    self.personagens.where("imagem is not null" );
  end
  
  def temporadas_validas_ordenadas
    self.temporadas.where("temporadas.temporada <> 0").order("temporadas.temporada desc")
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
  
  def marcar_como_vista(user,finalizou=false)
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Serie' and avaliavel_id=#{self.id} and user_id=#{user.id} ")
    if aval.empty? 
      aval = Avaliacao.new
      aval.user = user
      acompanhamento = criar_acompanhamento(aval, finalizou)
      self.avaliacoes << aval
      self.save
    else
      if self.finalizada? && finalizou
        aval_banco = aval.first
        if !aval_banco.acompanhamento_serie.finalizada
          aval_banco.acompanhamento_serie.finalizada = true
          aval_banco.acompanhamento_serie.ativa = false
          aval_banco.acompanhamento_serie.geladeira = false
          aval_banco.acompanhamento_serie.save
        end        
      end
    end 
  end

  def criar_acompanhamento(aval, finalizou)
    acompanhamento= AcompanhamentoSerie.new
    if finalizou
      if self.finalizada?
        acompanhamento.finalizada = true
        acompanhamento.ativa = false
        acompanhamento.geladeira = false
      else
        acompanhamento.ativa = true
        acompanhamento.finalizada = false
        acompanhamento.geladeira = false
      end
    else
        acompanhamento.ativa = true
        acompanhamento.finalizada = false
        acompanhamento.geladeira = false
    end
    acompanhamento.avaliacao = aval
    aval.acompanhamento_serie = acompanhamento
  end  

  def marcar_inteira(user)
    self.temporadas_validas_ordenadas.each do |temporada|
      temporada.episodios_ordenados_exibicao.each do |episodio|
        if episodio.estreia && episodio.estreia < Time.now
          episodio.marcar_como_visto(user)
        end
      end
    end
    self.marcar_como_vista(user, true)
  end
  
  def finalizada?
    self.status.eql? "Finalizada"
  end
end
