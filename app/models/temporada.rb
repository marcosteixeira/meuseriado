#coding: utf-8
class Temporada < ActiveRecord::Base
  extend FriendlyId
  acts_as_commontable

  friendly_id :gerar_slug, use: :slugged

  belongs_to :serie
  has_many :episodios, :through => :serie
  has_many :avaliacoes, as: :avaliavel

  def episodios_ordenados_exibicao
    self.serie.episodios.where({temporada: self.temporada}).order("temporada desc, numero desc")
  end

  def episodios_ordenados_exibicao_passado
    self.serie.episodios.where("temporada = #{self.temporada} and ativo = 1 ").order("temporada asc, numero asc")
  end

  def media_geral
    Avaliacao.where("avaliavel_type = 'Episodio' and avaliavel_id in (select id from episodios where temporada = #{self.temporada} and serie_id = #{self.serie.id})").average('nota')
  end

  def data_lancamento
    e = Episodio.find_by_sql("select estreia from episodios where serie_id = #{self.serie.id} and temporada =  #{self.temporada} and numero = 1")
    if !e.empty?
      e.first.estreia
    end
  end

  def gerar_slug
    "#{self.temporada}"
  end

  def marcar_como_vista(user, nota= nil, notifica=false)
    self.episodios_ordenados_exibicao_passado.each do |episodio|
      episodio.marcar_como_visto(user)
    end

    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Temporada' and avaliavel_id=#{self.id} and user_id=#{user.id} ")

    if aval.empty?
      aval = Avaliacao.new
      aval.user = user

      if nota
        aval.nota = nota
      end
      self.avaliacoes << aval
      self.save

      if notifica && user.notifica?
        begin
          graph = Koala::Facebook::API.new(user.token)
          graph.put_wall_post("Acabei de assistir a temporada #{self.temporada} de #{self.serie.nome_exibicao} e marquei lá no MeuSeriado", {:name => "MeuSeriado - #{self.serie.nome_exibicao} - Temporada #{self.temporada}", :link => "http://meuseriado.com.br/temporadas/#{self.slug}"}, user.uid)
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
          graph.put_wall_post("Acabei de dar nota para a temporada #{self.temporada} de #{self.serie.nome_exibicao} lá no MeuSeriado", {:name => "MeuSeriado - #{self.serie.nome_exibicao} - Temporada #{self.temporada}", :link => "http://meuseriado.com.br/temporadas/#{self.slug}"}, user.uid)
          notific = Notificacao.new
          notific.user = user
          notific.save
        rescue => e
          #faz nada
        end
      end
    end
  end

  def desmarcar_como_vista(user)
    self.episodios_ordenados_exibicao_passado.each do |episodio|
      episodio.desmarcar_como_visto(user)
    end

    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Temporada' and avaliavel_id=#{self.id} and user_id=#{user.id} ")

    if !aval.empty?
      aval.first.destroy
    end
  end

  def nome_temporada_formatado
    "#{self.serie.nome} - Temporada #{self.temporada}"
  end

  def nota_user(user=nil)
    if user
      aval_user = self.avaliacoes.where(user: user)
      if !aval_user.empty?
        aval_user.first.nota
      end
    end
  end

  def percentual(user)
    return 0 unless user.viu_temporada?
    episodios_vistos_temporada = user.episodios(self.serie.id, self.temporada)
    return episodios_vistos_temporada
  end


end
