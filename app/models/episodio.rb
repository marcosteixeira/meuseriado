class Episodio < ActiveRecord::Base
  extend FriendlyId
  friendly_id :gerar_slug, use: :slugged
  
  belongs_to :serie, :dependent => :delete
  has_many :avaliacoes, as: :avaliavel
    
  def gerar_slug
   [[ self.serie.nome, self.temporada, self.numero, self.nome],
   [ self.serie.nome, self.temporada, self.numero]]
  end

  def nome_episodio_formatado
    "#{self.serie.nome} #{self.nome_episodio}"
  end
  
  def nome_episodio
    "S%02dE%02d" % [self.temporada, self.numero]
  end
  
  def marcar_como_visto(user)
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Episodio' and avaliavel_id=#{self.id} and user_id=#{user.id} ")
    
    if aval.empty? 
      aval = Avaliacao.new
      aval.user = user
      self.avaliacoes << aval
      self.save
    end 
  end
  
  def desmarcar_como_visto(user)
    aval = Avaliacao.find_by_sql("select * from avaliacoes where avaliavel_type='Episodio' and avaliavel_id=#{self.id} and user_id=#{user.id} ")
    
    if !aval.empty? 
      aval.first.destroy
    end 
  end

  
end
