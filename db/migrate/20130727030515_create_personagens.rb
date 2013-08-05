class CreatePersonagens < ActiveRecord::Migration
  def change
    create_table :personagens do |t|
      t.string :imagem
      t.string :nome, :null => false, :default => ""
      t.integer :serie_id
      t.integer :aparicao
      t.integer :ator_id, :null => false, :default => ""
      t.string :slug
      t.timestamps
    end
    add_index :personagens, :slug, unique: true
    add_foreign_key(:personagens, :atores)
    add_foreign_key(:personagens, :series)
  end
end
