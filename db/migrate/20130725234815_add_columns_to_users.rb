class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :slug, :string
    add_column :users, :imagem, :string, :default => "../assets/series/imagem_padrao.jpg"
    add_index  :users, :slug, unique: true
  end
end
