class CreateAvaliacoes < ActiveRecord::Migration
  def change
    create_table :avaliacoes do |t|
      t.text :texto, :limit => 64.kilobytes + 1
      t.string :nota
      t.integer :avaliavel_id, :null => false
      t.integer :user_id, :null => false
      t.string :avaliavel_type, :null => false

      t.timestamps
    end
    add_foreign_key(:avaliacoes, :users)
    add_index :avaliacoes, :avaliavel_type
    add_index :avaliacoes, :avaliavel_id
  end
end
