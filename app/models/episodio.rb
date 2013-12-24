#coding: utf-8
class Episodio < ActiveRecord::Base
  extend FriendlyId
  friendly_id :gerar_slug, use: :slugged
  acts_as_commontable

  belongs_to :serie, :dependent => :delete
  has_many :avaliacoes, as: :avaliavel

  def gerar_slug
    [self.serie.nome_exibicao, self.temporada, self.numero]
  end

  def nome_episodio_formatado
    "#{self.serie.nome_exibicao} #{self.nome_episodio}"
  end

  def nome_episodio
    "S%02dE%02d" % [self.temporada, self.numero]
  end

  def marcar_como_visto(user, nota=nil, notificar=false)
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
      if notificar && user.notifica?
        begin
          graph = Koala::Facebook::API.new(user.token)
          graph.put_wall_post("Acabei de assistir #{self.nome_episodio_formatado} e marquei lá no MeuSeriado", {:name => "MeuSeriado - #{self.nome_episodio_formatado} - #{self.nome}", :link => "http://meuseriado.com.br/episodios/#{self.slug}"}, user.uid)
        rescue => e
          #faz nada
        end
      end
    elsif nota
      aval.first.nota = nota
      aval.first.save
      if user.notifica?
        begin
          graph = Koala::Facebook::API.new(user.token)
          graph.put_wall_post("Acabei de dar nota #{nota}/5 para #{self.nome_episodio_formatado} lá no MeuSeriado", {:name => "MeuSeriado - #{self.nome_episodio_formatado}", :link => "http://meuseriado.com.br/episodios/#{self.slug}"}, user.uid)
          notific = Notificacao.new
          notific.user = user
          notific.save
        rescue => e
          #faz nada
        end
      end
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
