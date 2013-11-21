class Avaliacao < ActiveRecord::Base
  belongs_to :avaliavel, polymorphic: true
  belongs_to :user
  has_one :acompanhamento_serie, :dependent => :delete
  after_create :criar_visualizacao
  after_destroy :excluir_visualizacao

  def criar_visualizacao
    if self.avaliavel_type.eql? "Episodio"
      Visualizacao.create(serie: self.avaliavel.serie)
    end
  end

  def excluir_visualizacao
    if self.avaliavel_type.eql? "Episodio"
      Visualizacao.first.destroy
    end
  end
end
