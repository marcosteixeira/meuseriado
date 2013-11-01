class HomeController < ApplicationController

  before_filter :authenticate_user!, :except => [:index]

  def index

    @episodios = Episodio.find_by_sql("select * from episodios where id in (select avaliavel_id from avaliacoes where avaliavel_type = 'Episodio' and created_at > '#{1.week.ago}') group by serie_id order by count(*) desc limit 9")
    contagem = @episodios.size

    if contagem - 9 < 0
      Episodio.where("banner IS NOT NULL").sample((contagem - 9).abs).each do |ep|
        @episodios << ep
      end
    end

    @avaliacoes = Avaliacao.where("avaliavel_type = 'Episodio'").limit(10).order("id desc")
    @episodios_top = Episodio.find_by_sql("SELECT episodio.* FROM commontator_comments comment, commontator_threads thread, episodios episodio where comment.thread_id = thread.id and episodio.id = thread.commontable_id and thread.commontable_type = 'Episodio' group by thread.commontable_id order by count(thread.commontable_id) desc limit 10")

  end


  def onde_parei
  end

end
