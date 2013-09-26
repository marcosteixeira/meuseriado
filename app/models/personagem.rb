class Personagem < ActiveRecord::Base
  extend FriendlyId
  friendly_id :gerar_slug, use: :slugged

  belongs_to :ator
  belongs_to :serie
  has_many :avaliacoes, as: :avaliavel

  def gerar_slug
    if nome
      "#{self.nome}"
    else
      "#{self.serie.nome}-#{self.ator.nome}"
    end
  end
end
