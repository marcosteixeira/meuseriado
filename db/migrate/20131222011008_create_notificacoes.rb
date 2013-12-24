class CreateNotificacoes < ActiveRecord::Migration
  def change
    create_table :notificacoes do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
