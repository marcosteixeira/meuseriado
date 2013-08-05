module Tvdbr
  class Actor < DataSet
    alias_property :id, :id
    alias_property :image, :image
    alias_property :name, :name
    alias_property :role, :character_name
    alias_property :sort_order, :sort_order
    absolutize :image
  end
end