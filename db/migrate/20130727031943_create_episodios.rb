class CreateEpisodios < ActiveRecord::Migration
  def change
    create_table :episodios do |t|
      t.integer :numero, :null => false, :default => ""
      t.integer :temporada, :null => false, :default => ""
      t.integer :serie_id, :null => false, :default => ""
      t.string :nome
      t.string :diretor
      t.string :banner
      t.string :id_imdb
      t.text :sinopse, :limit => 64.kilobytes + 1
      t.string :atores_convidados
      t.integer :numero_absoluto
      t.string :nota
      t.datetime :estreia
      t.string :escritores
      t.string :slug
      t.timestamps
    end
    add_index :episodios, :slug, unique: true
    add_foreign_key(:episodios, :series)
  end
end
