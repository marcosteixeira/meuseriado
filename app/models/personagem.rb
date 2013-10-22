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

  def marcar(user, nota=nil)
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Personagem' and avaliavel_id=#{self.id} and user_id=#{user.id} ")

    if aval.empty?
      aval = Avaliacao.new
      aval.user = user

      if nota
        aval.nota = nota
      end

      self.avaliacoes << aval
      self.save
    elsif nota
      aval.first.nota = nota
      aval.first.save
    end
  end

  def desmarcar(user)
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Personagem' and avaliavel_id=#{self.id} and user_id=#{user.id} ")

    if !aval.empty?
      aval.first.destroy
    end
  end

  def nota_user(user=nil)
    if user
      aval_user = self.avaliacoes.where(user: user)
      if !aval_user.empty?
        aval_user.first.nota
      end
    end
  end

end
