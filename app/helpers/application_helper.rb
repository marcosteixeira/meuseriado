module ApplicationHelper
   def date(the_date)
      if !the_date.nil? 
         the_date.strftime("%d/%m/%y")
      end
   end
   
   def listar_temporada(temporada)
    render partial: "series/listar_temporada",
    locals: {temporada: temporada}
   end
  
  def listar_series_usuario(acompanhamentos_series, user)
    render partial: "users/listar_series_usuario",
    locals: {acompanhamentos_series: acompanhamentos_series, user: user}
  end
  
  def ultimas_atualizacoes(user)
    render partial: "users/ultimas_atualizacoes",
    locals: {user: user}
  end

  def gerando_assunto(avaliacoes)
    render partial: "home/gerando_assunto",
    locals: {avaliacoes: avaliacoes}
  end
  
  def rolando_agora(avaliacoes)
    render partial: "home/rolando_agora",
    locals: {avaliacoes: avaliacoes}
  end


end
