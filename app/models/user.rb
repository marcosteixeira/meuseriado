class User < ActiveRecord::Base
      extend FriendlyId
 
  friendly_id :name, use: :slugged

  require 'serie'
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook,:google_oauth2]
         
  has_attached_file :avatar,
      :path => ":rails_root/app/assets/images/series/users/:id/:filename",
      :url => "/images/series/:id/:filename"
      
  has_many :avaliacoes, :dependent => :delete_all
	
	def user_params
	    params.require(:user).permit(:name, :provider, :uid, :name, :avatar)
	end
	
	def imagem_formatada
	  if self.avatar_file_name
	    "../series/users/#{self.id}/#{self.avatar_file_name}"
	  else
	    self.imagem
	  end
	end
	
	def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  user = User.where(:provider => auth.provider, :uid => auth.uid).first
  unless user
    user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20],
                         imagem: "https://graph.facebook.com/#{auth.uid}/picture?width=300&height=441"
                         )
  end
  user
  end
  
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
        user = User.create(name: data["name"],
             email: data["email"],
             password: Devise.friendly_token[0,20]
            )
    end
    user
  end
  
end
