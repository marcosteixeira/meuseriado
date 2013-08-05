class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.string :nome,              :null => false, :default => ""
      t.string :dia_exibicao
      t.string :horario_exibicao
      t.string :banner
      t.string :fanart
      t.datetime :estreia
      t.string :id_imdb
      t.text :sinopse,   :limit => 64.kilobytes + 1
      t.string :nota
      t.integer :duracao_episodio
      t.string :status
      t.string :poster
      t.integer :produtora_id
      t.string :slug
      t.timestamps
    end
    add_index :series, :nome, unique: true
    add_index :series, :slug, unique: true
    add_foreign_key(:series, :produtoras)
  end
end
