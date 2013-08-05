class CreateTemporadas < ActiveRecord::Migration
  def change
    create_table :temporadas do |t|
      t.string :imagem
      t.integer :serie_id
      t.integer :temporada
      t.string :slug
      t.timestamps
    end
    
    add_index :temporadas, :slug, unique: true
    add_foreign_key(:temporadas, :series)
  end
end
