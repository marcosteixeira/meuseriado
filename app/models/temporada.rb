class Temporada < ActiveRecord::Base
     extend FriendlyId
 
  friendly_id :gerar_slug, use: :slugged
  
  belongs_to :serie
  has_many :episodios, :through => :serie
  has_many :avaliacoes, as: :avaliavel
  
  def episodios_ordenados_exibicao
    self.serie.episodios.where({temporada: self.temporada }).order("temporada desc, numero desc")
  end 
  
  def episodios_ordenados_exibicao_passado
    self.serie.episodios.where("temporada = #{self.temporada} and estreia <  '#{Time.now}' ").order("temporada asc, numero asc")
  end  
  
  def media_geral
    Avaliacao.where("avaliavel_type = 'Episodio' and avaliavel_id in (select id from episodios where temporada = #{self.temporada} and serie_id = #{self.serie.id})").average('nota')
  end
  
  def data_lancamento
    e = Episodio.find_by_sql("select estreia from episodios where serie_id = #{self.serie.id} and temporada =  #{self.temporada} and numero = 1" )
    if !e.empty?
      e.first.estreia
    end
  end
  
  def gerar_slug
   "#{self.temporada}"
  end
end
