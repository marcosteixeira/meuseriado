class Batalha < ActiveRecord::Base
  extend FriendlyId
  friendly_id :gerar_slug, use: :slugged
  acts_as_commentable
  acts_as_votable

  belongs_to :desafiante, :class_name => "Serie"
  belongs_to :desafiada, :class_name => "Serie"

  belongs_to :user

  def gerar_slug
    "#{desafiante.slug}-vs-#{desafiada.slug}"
  end

  def nome
    "#{desafiante.nome_exibicao} VS #{desafiada.nome_exibicao}"
  end

  #@batalha.vote :voter => @user5, :vote => 'like', :vote_scope => 'neutro'
end
