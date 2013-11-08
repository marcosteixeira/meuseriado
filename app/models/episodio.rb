class Episodio < ActiveRecord::Base
  extend FriendlyId
  friendly_id :gerar_slug, use: :slugged
  acts_as_commontable

  belongs_to :serie, :dependent => :delete
  has_many :avaliacoes, as: :avaliavel

  def gerar_slug
    [[self.serie.nome, self.temporada, self.numero, self.nome],
     [self.serie.nome, self.temporada, self.numero]]
  end

  def nome_episodio_formatado
    "#{self.serie.nome} #{self.nome_episodio}"
  end

  def nome_episodio
    "S%02dE%02d" % [self.temporada, self.numero]
  end

  def marcar_como_visto(user, nota=nil)
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Episodio' and avaliavel_id=#{self.id} and user_id=#{user.id} ")
    user.indice_acompanhamento = user.indice_acompanhamento + 1
    user.save

    aval_serie = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Serie' and avaliavel_id=#{self.serie.id} and user_id=#{user.id} ").first
    aval_serie.ordem = user.indice_acompanhamento
    aval_serie.save

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

  def desmarcar_como_visto(user)
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Episodio' and avaliavel_id=#{self.id} and user_id=#{user.id} ")

    if !aval.empty?
      serie = aval.first.avaliavel.serie
      aval.first.destroy

      if !user.viu_serie?(serie)
        serie.desmarcar_como_vista(user)
      end
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

  def proximo
    eps = self.serie.episodios.to_a
    return eps[eps.index(self) + 1]
  end

  def percentual_conclusao_temporada
    numero.to_f / Episodio.where(temporada: self.temporada, serie: self.serie).count.to_f * 100.0
  end
end
