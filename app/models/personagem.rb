class Personagem < ActiveRecord::Base
    extend FriendlyId
  friendly_id :nome, use: :slugged
  
  belongs_to :ator
  belongs_to :serie
  has_many :avaliacoes, as: :avaliavel
  
end
