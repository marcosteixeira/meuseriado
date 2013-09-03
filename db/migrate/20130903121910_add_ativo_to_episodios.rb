class AddAtivoToEpisodios < ActiveRecord::Migration
  def change
    add_column :episodios, :ativo, :boolean
  end
end
