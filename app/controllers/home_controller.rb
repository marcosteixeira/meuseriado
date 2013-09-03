class HomeController < ApplicationController

  def index
  
    @episodios = Episodio.find_by_sql("select * from episodios where id in (select avaliavel_id from avaliacoes where avaliavel_type = 'Episodio' and created_at > '#{1.week.ago}') group by serie_id order by count(*) desc limit 9")
    @avaliacoes = Avaliacao.where("avaliavel_type = 'Episodio'").order("id desc").limit(10)
    
  end
end
