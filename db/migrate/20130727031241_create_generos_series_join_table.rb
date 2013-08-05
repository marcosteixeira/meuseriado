class CreateGenerosSeriesJoinTable < ActiveRecord::Migration
  def change
    create_table :generos_series, id: false do |t|
      t.integer :serie_id
      t.integer :genero_id
    end
    
    add_foreign_key(:generos_series, :series)
    add_foreign_key(:generos_series, :generos)
  end
  
  def self.down
    drop_table :generos_series
  end
end
