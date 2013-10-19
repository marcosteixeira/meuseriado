class Personagem < ActiveRecord::Base
  extend FriendlyId
  friendly_id :gerar_slug, use: :slugged
  acts_as_commontable

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

  def marcar(user)
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Personagem' and avaliavel_id=#{self.id} and user_id=#{user.id} ")

    if aval.empty?
      aval = Avaliacao.new
      aval.user = user
      self.avaliacoes << aval
      self.save
    end
  end

  def desmarcar(user)
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Personagem' and avaliavel_id=#{self.id} and user_id=#{user.id} ")

    if !aval.empty?
      aval.first.destroy
    end
  end
end
