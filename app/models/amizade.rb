class Amizade < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id' 
  belongs_to :amigo, :class_name => 'User', :foreign_key => 'amigo_id'
end
