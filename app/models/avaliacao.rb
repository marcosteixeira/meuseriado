class Avaliacao < ActiveRecord::Base
  belongs_to :avaliavel, polymorphic: true
  belongs_to :user
end
