class AddKeys2 < ActiveRecord::Migration
  def change
    add_foreign_key "commontator_comments", "commontator_threads", name: "commontator_comments_thread_id_fk", column: "thread_id"
    add_foreign_key "commontator_subscriptions", "commontator_threads", name: "commontator_subscriptions_thread_id_fk", column: "thread_id"
  end
end
