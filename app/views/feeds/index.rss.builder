xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Meu Seriado"
    xml.description "Organizando suas séries"
    xml.link "http://meuseriado.com.br/"

    for serie in @series
      xml.item do
        xml.title serie.nome_exibicao
        xml.description serie.sinopse
        xml.pubDate serie.created_at.to_s(:rfc822)
        xml.link serie_url(serie)
        xml.guid serie_url(serie)
      end
    end
  end
end