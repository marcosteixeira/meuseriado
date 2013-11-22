class User < ActiveRecord::Base
  extend FriendlyId
  include Amistad::FriendModel
  acts_as_commontator

  friendly_id :name, use: :slugged

  require 'serie'
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  has_attached_file :avatar,
                    :path => ":rails_root/app/assets/images/series/users/:id/:filename",
                    :url => "/images/series/:id/:filename"

  has_many :avaliacoes, :dependent => :delete_all, :order => 'id DESC'
  has_many :series_vistas, :through => :avaliacoes, :source => :acompanhamento_serie, :include => {avaliacao: :avaliavel}

  def series
    Serie.find_by_sql("SELECT  `series`.* FROM `series` INNER JOIN `avaliacoes` ON `series`.`id` = `avaliacoes`.`avaliavel_id` WHERE `avaliacoes`.`user_id` = #{self.id} AND `avaliacoes`.`avaliavel_type` = 'Serie'  ORDER BY id DESC")
  end

  def episodios(serie_id=nil, temporada_numero = nil, order=nil)
    if serie_id
      if !temporada_numero
        Episodio.find_by_sql("SELECT `episodios`.* FROM `episodios` INNER JOIN `avaliacoes` ON `episodios`.`id` = `avaliacoes`.`avaliavel_id` WHERE `avaliacoes`.`user_id` = #{self.id} AND `avaliacoes`.`avaliavel_type` = 'Episodio' AND episodios.serie_id = #{serie_id}  #{order}")
      else
        Episodio.find_by_sql("SELECT `episodios`.* FROM `episodios` INNER JOIN `avaliacoes` ON `episodios`.`id` = `avaliacoes`.`avaliavel_id` WHERE `avaliacoes`.`user_id` = #{self.id} AND `avaliacoes`.`avaliavel_type` = 'Episodio' AND episodios.serie_id = #{serie_id} AND episodios.temporada = #{temporada_numero} #{order}")
      end
    else
      Episodio.find_by_sql("SELECT `episodios`.* FROM `episodios` INNER JOIN `avaliacoes` ON `episodios`.`id` = `avaliacoes`.`avaliavel_id` WHERE `avaliacoes`.`user_id` = #{self.id} AND `avaliacoes`.`avaliavel_type` = 'Episodio' #{order}")
    end
  end

  def ultimo_episodio_visto(serie_id)
    eps = episodios(serie_id, nil, "order by temporada desc, numero desc")
    if eps.present?
      eps.first
    end
  end

  def temporadas
    #Temporada.find_by_sql("SELECT `temporadas`.* FROM `temporadas` INNER JOIN `avaliacoes` ON `temporadas`.`id` = `avaliacoes`.`avaliavel_id` WHERE `avaliacoes`.`user_id` = #{self.id} AND `avaliacoes`.`avaliavel_type` = 'Temporada'")
    avaliacoes.where(avaliavel_type: "Temporada").includes(:avaliavel).map do |aval|
      aval.avaliavel
    end
  end

  def personagens
    #Personagem.find_by_sql("SELECT `personagens`.* FROM `personagens` INNER JOIN `avaliacoes` ON `personagens`.`id` = `avaliacoes`.`avaliavel_id` WHERE `avaliacoes`.`user_id` = #{self.id} AND `avaliacoes`.`avaliavel_type` = 'Personagem'  ORDER BY id DESC")
    avaliacoes.where(avaliavel_type: "Personagem").includes({avaliavel: :serie}).map do |aval|
      aval.avaliavel
    end
  end

  def user_params
    params.require(:user).permit(:name, :provider, :uid, :name, :avatar)
  end

  def imagem_formatada
    if self.avatar_file_name
      "/images/series/users/#{self.id}/#{self.avatar_file_name}"
    elsif self.imagem
      self.imagem
    else
      "/images/series/imagem_padrao.jpg"
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name: auth.extra.raw_info.name,
                         provider: auth.provider,
                         uid: auth.uid,
                         email: auth.info.email,
                         password: Devise.friendly_token[0, 20],
                         imagem: "https://graph.facebook.com/#{auth.uid}/picture?type=large",
                         token: auth.credentials.token,
                         token_expire_at: Time.at(auth.credentials.expires_at)

      )
    end

    if user.troca_token?
      user.token = auth.credentials.token
      user.token_expire_at = Time.at(auth.credentials.expires_at)
      user.save
    end
    user
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
      user = User.create(name: data["name"],
                         email: data["email"],
                         imagem: data["image"],
                         password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

  def viu_serie?(serie)
    self.series.include? serie
  end

  def viu_episodio?(episodio)
    self.episodios.include? episodio
  end

  def notas_episodios(serie=nil)
    if serie
      Episodio.find_by_sql("SELECT * FROM `episodios` INNER JOIN `avaliacoes` ON `episodios`.`id` = `avaliacoes`.`avaliavel_id` WHERE `avaliacoes`.`user_id` = #{self.id} AND `avaliacoes`.`avaliavel_type` = 'Episodio' AND avaliacoes.nota is not null and serie_id = #{serie.id} ")
    else
      Episodio.find_by_sql("SELECT * FROM `episodios` INNER JOIN `avaliacoes` ON `episodios`.`id` = `avaliacoes`.`avaliavel_id` WHERE `avaliacoes`.`user_id` = #{self.id} AND `avaliacoes`.`avaliavel_type` = 'Episodio' AND avaliacoes.nota is not null")
    end
  end

  def notas_dadas
    self.avaliacoes.where("nota IS NOT NULL")
  end

  def media_serie(serie)
    Avaliacao.where("avaliavel_type = 'Episodio' and avaliavel_id in (select id from episodios where serie_id = #{serie.id})").average('nota')
  end

  def viu_temporada? (temporada)
    self.temporadas.include?(temporada)
  end

  def fa? (personagem)
    self.personagens.include?(personagem)
  end

  def troca_token?
    !self.token.present? || self.token_expire_at < Time.now
  end

  class << self
    def current_user=(user)
      Thread.current[:current_user] = user
    end

    def current_user
      Thread.current[:current_user]
    end
  end

  #@graph.put_wall_post("BlablaBla- Dexter", {:name => "Nome - Dexter", :link => "http://meuseriado.com.br/episodios/dexter-8-12-remember-the-monsters"}, "100002077371868")

end
