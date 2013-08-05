class Temporada < ActiveRecord::Base
     extend FriendlyId
 
  friendly_id :temporada, use: :slugged
  
  belongs_to :serie
  has_many :episodios, :through => :serie

  def episodios_ordenados_exibicao
    self.serie.episodios.where({temporada: self.temporada }).order("temporada desc, numero desc")
  end  
  
  def media_geral
    Avaliacao.where("avaliavel_type = 'Episodio' and avaliavel_id in (select id from episodios where temporada = #{self.temporada} and serie_id = #{self.serie.id})").average('nota')
  end
end
