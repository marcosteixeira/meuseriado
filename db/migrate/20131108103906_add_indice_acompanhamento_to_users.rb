class AddIndiceAcompanhamentoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :indice_acompanhamento, :int, :default => 0
  end
end
