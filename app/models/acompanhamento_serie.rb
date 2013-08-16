class AcompanhamentoSerie < ActiveRecord::Base
    belongs_to :avaliacao, :dependent => :delete
end
