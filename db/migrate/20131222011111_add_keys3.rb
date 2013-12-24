class AddKeys3 < ActiveRecord::Migration
  def change
    add_foreign_key "notificacoes", "users", name: "notificacoes_user_id_fk"
  end
end
