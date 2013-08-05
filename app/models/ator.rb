class Ator < ActiveRecord::Base
   extend FriendlyId
  friendly_id :nome, use: :slugged
  
  has_many :personagens, dependent: :nullify
  has_many :avaliacoes, as: :avaliavel
end
