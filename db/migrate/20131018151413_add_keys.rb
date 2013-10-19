class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "friendships", "users", name: "friendships_blocker_id_fk", column: "blocker_id"
    add_foreign_key "friendships", "users", name: "friendships_friend_id_fk", column: "friend_id"
    add_foreign_key "friendships", "users", name: "friendships_friendable_id_fk", column: "friendable_id"
  end
end
