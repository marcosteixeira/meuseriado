class CreateAcompanhamentoSeries < ActiveRecord::Migration
  def change
    create_table :acompanhamento_series, :id => false do |t|
      t.integer :serie_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :ativa
      t.boolean :finalizada
      t.boolean :geladeira
      t.timestamps
    end
    add_foreign_key(:acompanhamento_series, :series)
    add_foreign_key(:acompanhamento_series, :users)
    add_index :acompanhamento_series, [:serie_id,:user_id], unique: true
  end
end
