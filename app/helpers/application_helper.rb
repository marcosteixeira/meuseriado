module ApplicationHelper
   def date(the_date)
      if !the_date.nil? 
         the_date.strftime("%d.%m.%y %H:%M")
      end
   end
   
   def listar_temporada(temporada)
    render partial: "series/listar_temporada",
    locals: {temporada: temporada}
   end
end
