class AddNomeExibicaoAndVisualizacoesToSerie < ActiveRecord::Migration
  def change
    add_column :series, :nome_exibicao, :string
    add_column :series, :visualizacoes, :int, :default => 0
  end
end
