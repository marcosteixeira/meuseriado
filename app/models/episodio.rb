class Episodio < ActiveRecord::Base
  extend FriendlyId
  friendly_id :gerar_slug, use: :slugged
  
  belongs_to :serie, :dependent => :delete
  has_many :avaliacoes, as: :avaliavel
    
  def gerar_slug
   [[ self.serie.nome, self.temporada, self.numero, self.nome],
   [ self.serie.nome, self.temporada, self.numero]]
  end
  def nome_episodio_formatado
    "#{self.serie.nome} S%02dE%02d" % [self.temporada, self.numero]
  end
end
