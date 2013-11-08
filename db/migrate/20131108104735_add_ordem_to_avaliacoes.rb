class AddOrdemToAvaliacoes < ActiveRecord::Migration
  def change
    add_column :avaliacoes, :ordem, :int, :default => 0
  end
end
