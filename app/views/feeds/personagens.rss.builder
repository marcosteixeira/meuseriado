xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Meu Seriado"
    xml.description "Organizando suas séries"
    xml.link "http://meuseriado.com.br/"

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