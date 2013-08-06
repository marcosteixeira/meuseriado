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
    self.personagens.where("imagem is not null" ).limit(8);
  end
  
  def temporadas_validas_ordenadas
    self.temporadas.where("temporadas.temporada <> 0").order("temporadas.temporada desc")
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
        return "../images/series/imagem_padrao.jpg"
      end
      "../images/series/#{pasta}#{nome_imagem}"
    end
  end
end
