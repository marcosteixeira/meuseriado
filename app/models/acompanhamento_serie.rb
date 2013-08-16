class AcompanhamentoSerie < ActiveRecord::Base
    belongs_to :serie, :dependent => :delete
    belongs_to :user, :dependent => :delete
end
