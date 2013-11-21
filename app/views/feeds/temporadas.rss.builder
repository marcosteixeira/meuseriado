xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Meu Seriado"
    xml.description "Organizando suas séries"
    xml.link "http://meuseriado.com.br/"

    for temporada in @temporadas
      xml.item do
        xml.title temporada.nome_temporada_formatado
        xml.description temporada.nome_temporada_formatado
        xml.pubDate temporada.created_at.to_s(:rfc822)
        xml.link "http://meuseriado.com.br/series/#{temporada.serie.slug}/temporadas/#{temporada.temporada}"
        xml.guid "http://meuseriado.com.br/series/#{temporada.serie.slug}/temporadas/#{temporada.temporada}"
      end
    end
  end
end