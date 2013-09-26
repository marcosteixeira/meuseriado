xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Meu Seriado"
    xml.description "Organizando suas séries"
    xml.link "http://meuseriado.com.br/"

    for serie in @series
      xml.item do
        xml.title serie.nome
        xml.description serie.sinopse
        xml.pubDate serie.created_at.to_s(:rfc822)
        xml.link serie_url(serie)
        xml.guid serie_url(serie)
      end
    end

    for episodio in @episodios
      xml.item do
        xml.title episodio.nome_episodio_formatado
        xml.description episodio.sinopse
        xml.pubDate episodio.created_at.to_s(:rfc822)
        xml.link episodio_url(episodio)
        xml.guid episodio_url(episodio)
      end
    end

    for temporada in @temporadas
      xml.item do
        xml.title temporada.nome_temporada_formatado
        xml.description temporada.nome_temporada_formatado
        xml.pubDate temporada.created_at.to_s(:rfc822)
        xml.link "http://meuseriado.com.br/series/#{temporada.serie.slug}/temporadas/#{temporada.temporada}"
        xml.guid "http://meuseriado.com.br/series/#{temporada.serie.slug}/temporadas/#{temporada.temporada}"
      end
    end

    for personagem in @personagens
      xml.item do
        xml.title personagem.nome
        xml.description "#{personagem.serie.nome} - #{personagem.nome}"
        xml.pubDate personagem.created_at.to_s(:rfc822)
        xml.link "http://meuseriado.com.br/series/#{personagem.serie.slug}/personagens/#{personagem.slug}"
        xml.guid "http://meuseriado.com.br/series/#{personagem.serie.slug}/personagens/#{personagem.slug}"
      end
    end
  end
end