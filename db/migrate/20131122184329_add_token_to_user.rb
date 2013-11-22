class AddTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    add_column :users, :token_expire_at, :datetime
  end
end
