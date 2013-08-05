class Produtora < ActiveRecord::Base
    extend FriendlyId
  friendly_id :nome, use: :slugged
  
  has_many :series, dependent: :nullify
  has_many :avaliacoes, as: :avaliavel
end
