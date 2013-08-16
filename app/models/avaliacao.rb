class Avaliacao < ActiveRecord::Base
  belongs_to :avaliavel, polymorphic: true
  belongs_to :user
  has_one :acompanhamento_serie,  :dependent => :delete
end
