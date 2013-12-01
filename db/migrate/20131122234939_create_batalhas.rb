class CreateBatalhas < ActiveRecord::Migration
  def change
    create_table :batalhas do |t|
      t.integer :user_id, :null => false, :default => ""
      t.integer :desafiante_id, :null => false, :default => ""
      t.integer :desafiada_id, :null => false, :default => ""
      t.string :slug
    end
    add_index :batalhas, :slug, unique: true
    add_index :batalhas, [:desafiante_id, :desafiada_id], unique: true
    add_foreign_key(:batalhas, :users)
    add_foreign_key(:batalhas, :series, column: 'desafiante_id')
    add_foreign_key(:batalhas, :series, column: 'desafiada_id')
  end
end
