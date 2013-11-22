class Batalha < ActiveRecord::Base
  extend FriendlyId
  friendly_id :gerar_slug, use: :slugged

  belongs_to :desafiante, :class_name => "Serie"
  belongs_to :desafiada, :class_name => "Serie"

  belongs_to :user

  def gerar_slug
    "#{desafiante.slug}-vs-#{desafiada.slug}"
  end
end
