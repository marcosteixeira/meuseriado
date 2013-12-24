class AddNotificarAtualizacoesFbToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notificar_atualizacoes_fb, :boolean, default: true
  end
end
