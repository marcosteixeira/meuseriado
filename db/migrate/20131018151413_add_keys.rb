class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "comments", "comments", name: "comments_parent_id_fk", column: "parent_id"
    add_foreign_key "comments", "users", name: "comments_user_id_fk"
    add_foreign_key "friendships", "users", name: "friendships_blocker_id_fk", column: "blocker_id"
    add_foreign_key "friendships", "users", name: "friendships_friend_id_fk", column: "friend_id"
    add_foreign_key "friendships", "users", name: "friendships_friendable_id_fk", column: "friendable_id"
  end
end
