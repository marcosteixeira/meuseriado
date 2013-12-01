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
    "#{desafiante.nome_exibicao} x #{desafiada.nome_exibicao}"
  end

  def percentual(votos)
    a = votos.to_f / total_votos.to_f * 100.0
    return 0 unless !a.to_s.eql?("NaN")
    a
  end

  def total_votos
    likes_desafiante = self.desafiante.likes(:vote_scope => self.id).size
    likes_desafiada = self.desafiada.likes(:vote_scope => self.id).size
    qtde_neutros = self.likes(:vote_scope => "neutro").size

    likes_desafiante + likes_desafiada + qtde_neutros
  end

  def oponente(serie)
    if self.desafiada.eql? serie
      self.desafiante
    elsif self.desafiante.eql? serie
      self.desafiada
    else
      raise "Série não está nessa batalha"
    end
  end


  #@batalha.vote :voter => @user5, :vote => 'like', :vote_scope => 'neutro'
end
