class DropCommontatorTable < ActiveRecord::Migration
  def up
    drop_table :commontator_comments
    drop_table :commontator_subscriptions
    drop_table :commontator_threads
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
