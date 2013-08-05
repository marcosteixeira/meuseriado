class CreateProdutoras < ActiveRecord::Migration
  def change
    create_table :produtoras do |t|
      t.string :nome, :null => false, :default => ""
      t.string :slug
      t.timestamps
    end
    add_index :produtoras, :slug, unique: true
  end
end
