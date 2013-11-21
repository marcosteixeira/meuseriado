class CreateVisualizacoes < ActiveRecord::Migration
  def change
    create_table :visualizacoes do |t|
      t.integer :serie_id, :null => false, :default => ""
      t.timestamps
    end

    add_foreign_key(:visualizacoes, :series)
  end
end
