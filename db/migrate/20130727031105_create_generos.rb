class CreateGeneros < ActiveRecord::Migration
  def change
    create_table :generos do |t|
      t.string :nome, :null => false, :default => ""
      t.string :slug
      t.timestamps
    end
    add_index :generos, :slug, unique: true
  end
end
