class HomeController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :calendario]

  def index

    @series_top = Serie.top9

    @avaliacoes = Avaliacao.where("avaliavel_type = 'Episodio'").includes(:user, {avaliavel: :serie}).limit(10).order("id desc")
    @episodios_top = Episodio.find_by_sql("SELECT episodio.* FROM commontator_comments comment, commontator_threads thread, episodios episodio where comment.thread_id = thread.id and episodio.id = thread.commontable_id and thread.commontable_type = 'Episodio' group by thread.commontable_id order by count(thread.commontable_id) desc limit 10")

  end


  def onde_parei
  end

  def calendario
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @all =  params[:all] ? params[:all] : false

    if user_signed_in? && !@all
      @episodios = current_user.episodios_series(@date)
    else
      @episodios = Episodio.includes(:serie).where(:estreia => @date.beginning_of_month..@date.end_of_month).to_a
    end
  end

end
