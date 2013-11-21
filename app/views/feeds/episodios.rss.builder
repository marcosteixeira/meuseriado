xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Meu Seriado"
    xml.description "Organizando suas séries"
    xml.link "http://meuseriado.com.br/"

    for episodio in @episodios
      xml.item do
        xml.title episodio.nome_episodio_formatado
        xml.description episodio.sinopse
        xml.pubDate episodio.created_at.to_s(:rfc822)
        xml.link episodio_url(episodio)
        xml.guid episodio_url(episodio)
      end
    end
  end
end