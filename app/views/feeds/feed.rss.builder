xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Your Blog Title"
    xml.description "A blog about software and chocolate"
    xml.link posts_url

    for serie in @series
      xml.item do
        xml.title serie.nome
        xml.description serie.sinopse
        xml.pubDate serie.estreia.to_s(:rfc822)
        xml.link serie_url(serie)
        xml.guid serie_url(serie)
      end
    end
  end
end