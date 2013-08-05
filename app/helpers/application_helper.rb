module ApplicationHelper
   def date(the_date)
      if !the_date.nil? 
         the_date.strftime("%d.%m.%y %H:%M")
      end
   end
end
