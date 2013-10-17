class HomeController < ApplicationController

  def index

    @episodios = Episodio.find_by_sql("select * from episodios where id in (select avaliavel_id from avaliacoes where avaliavel_type = 'Episodio' and created_at > '#{1.week.ago}') group by serie_id order by count(*) desc limit 9")
    contagem = @episodios.size

    if contagem - 9 < 0
      Episodio.all.sample((contagem - 9).abs).each do |ep|
        @episodios << ep
      end
    end

    @avaliacoes = Avaliacao.where("avaliavel_type = 'Episodio'").order("id desc").limit(10)
    @episodios_top = @episodios

  end
end
