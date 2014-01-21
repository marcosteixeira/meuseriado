class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :falha,   :limit => 64.kilobytes + 1
      t.datetime :fim

      t.timestamps
    end
  end
end
