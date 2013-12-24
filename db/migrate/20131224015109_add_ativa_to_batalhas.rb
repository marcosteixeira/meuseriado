class AddAtivaToBatalhas < ActiveRecord::Migration
  def change
    add_column :batalhas, :ativa, :boolean, default: true
  end
end
