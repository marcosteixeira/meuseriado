class CreateAtores < ActiveRecord::Migration
  def change
    create_table :atores do |t|
      t.string :nome, :null => false, :default => ""
      t.string :slug
      t.timestamps
    end
    
    add_index :atores, :nome, unique: true
    add_index :atores, :slug, unique: true
  end
end
