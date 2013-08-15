class CreateAmizades < ActiveRecord::Migration
  def change
    create_table :amizades, :id => false  do |t|
        t.column :user_id,  :integer, :null => false 
        t.column :amigo_id, :integer, :null => false
    end
    
    add_foreign_key(:amizades, :users, column: 'user_id')
    add_foreign_key(:amizades, :users, column: 'amigo_id')
    add_index :amizades, [:user_id,:amigo_id], unique: true
  
  end
end
