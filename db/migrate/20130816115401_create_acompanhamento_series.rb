class CreateAcompanhamentoSeries < ActiveRecord::Migration
  def change
    create_table :acompanhamento_series do |t|
      t.integer :avaliacao_id, :null => false
      t.boolean :ativa
      t.boolean :finalizada
      t.boolean :geladeira
      t.boolean :abandonada
      t.timestamps
    end
    add_foreign_key(:acompanhamento_series, :avaliacoes)
    add_index :acompanhamento_series, :avaliacao_id, unique: true
  end
end
