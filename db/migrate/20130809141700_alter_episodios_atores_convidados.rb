class AlterEpisodiosAtoresConvidados < ActiveRecord::Migration
  def change
    change_column :episodios, :atores_convidados, :text , :limit => 64.kilobytes + 1
  end
end
