class HomeController < ApplicationController

  def index
    @primeira = Episodio.find_by_sql("select * from episodios where id in (select avaliavel_id from avaliacoes where avaliavel_type = 'Episodio') group by serie_id order by count(*) desc").first.serie
  end
end
