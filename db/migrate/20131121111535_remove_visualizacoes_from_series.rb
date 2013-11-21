class RemoveVisualizacoesFromSeries < ActiveRecord::Migration
  def change
    remove_column :series, :visualizacoes
  end
end
