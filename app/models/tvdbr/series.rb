module Tvdbr
  # { "ContentRating"=>"TV-MA", "Status"=>"Continuing", "Airs_Time"=>"9:00 PM", "FirstAired"=>"2006-10-01", "Runtime"=>"60",
  #   "banner"=>"graphical/79349-g7.jpg", "poster"=>"posters/79349-2.jpg", "id"=>"79349", "Genre"=>"|Action and Adventure|Drama|",
  #   "Network"=>"Showtime", "Overview"=>"...", "addedBy"=>nil, "lastupdated"=>"1295047217", "IMDB_ID"=>"tt0773262",
  #   "Language"=>"en", "SeriesName"=>"Dexter", "Rating"=>"9.3", "fanart"=>"fanart/original/79349-16.jpg",
  #   "Actors"=>"|Michael C. Hall|Julie Benz|", "Airs_DayOfWeek"=>"Sunday",
  #   "zap2it_id"=>"SH859795", "RatingCount"=>"678", "SeriesID"=>"62683" }
  class Series < DataSet
    alias_property :series_name, :title
    alias_property :overview, :synopsis
    alias_property :actors, :starring
    alias_property :genre, :categories
    alias_property :first_aired, :release_date
    listify :genre, :actors
    dateify :first_aired
    absolutize :fanart, :poster, :banner

    def episodes
      episode_data = self.parent.find_series_by_id(self.id, :all => true)
      return [] unless episode_data && episode_data['Episode']
      episode_data['Episode'].map { |e| Episode.new(self, e) if e && e.is_a?(Hash) }.compact
    end
    #tvdb = Tvdbr::Client.new
    #dexter =tvdb.find_series_by_title("Dexter")
    #dexter = tvdb.find_series_by_id(dexter.first.id)
    def actors_serie
      actors = []
      urls = self.parent.actor_urls(self.id)
      if !urls.nil?
        urls.each do |hash|
          actors<< novo_ator(hash)
        end
      end
      actors
    end
    
    def novo_ator(hash)
      if hash["Role"]
        personagem = Personagem.find_by_id(hash["id"])
        personagem||= Personagem.new
        personagem.id = hash["id"]
        if hash["Image"]
          personagem.imagem = Serie.salvar_imagem("http://www.thetvdb.com/banners/#{hash["Image"]}", hash["Image"].split("/").last, "personagem")
        else
          personagem.imagem = "../assets/series/imagem_padrao.jpg"
        end
             
        personagem.nome = hash["Role"]
        personagem.aparicao = hash["SortOrder"]
        personagem.ator = Ator.find_or_create_by(nome: hash["Name"])
        personagem
      end 
    end
    
    # Returns true if the series matches the given actors
    # actors = ['x', 'y', 'z']
    # series.actor_match?(actors) => true
    def actor_match?(actors)
      expected_actors   = actors.map      { |a| a.downcase.strip.gsub(/[\.\-\s\']/, '') }
      normalized_actors = self.actors.map { |a| a.downcase.strip.gsub(/[\.\-\s\']/, '') }
      # puts "1: #{self.inspect} - #{self.title} - #{normalized_actors.inspect} - #{expected_actors.inspect}"
      # puts "2: " + (normalized_actors & expected_actors).inspect
      normalized_actors.is_a?(Array) && expected_actors.is_a?(Array) &&
      (normalized_actors & expected_actors).size > 1
    end
    
  end
end
