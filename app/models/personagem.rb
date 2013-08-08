class Personagem < ActiveRecord::Base
    extend FriendlyId
  friendly_id :gerar_slug, use: :slugged
  
  belongs_to :ator
  belongs_to :serie
  has_many :avaliacoes, as: :avaliavel
  
  def gerar_slug
    if self.normalize_friendly_id(self.nome).empty?
      "#{self.serie.nome}-#{self.ator.id}"
    end
  end
end
