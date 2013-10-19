# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131018152642) do

  create_table "acompanhamento_series", force: true do |t|
    t.integer  "avaliacao_id", null: false
    t.boolean  "ativa"
    t.boolean  "finalizada"
    t.boolean  "geladeira"
    t.boolean  "abandonada"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "acompanhamento_series", ["avaliacao_id"], name: "index_acompanhamento_series_on_avaliacao_id", unique: true, using: :btree

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "atores", force: true do |t|
    t.string   "nome",       default: "", null: false
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "atores", ["nome"], name: "index_atores_on_nome", unique: true, using: :btree
  add_index "atores", ["slug"], name: "index_atores_on_slug", unique: true, using: :btree

  create_table "avaliacoes", force: true do |t|
    t.text     "texto",          limit: 16777215
    t.string   "nota"
    t.integer  "avaliavel_id",                    null: false
    t.integer  "user_id",                         null: false
    t.string   "avaliavel_type",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "avaliacoes", ["avaliavel_id"], name: "index_avaliacoes_on_avaliavel_id", using: :btree
  add_index "avaliacoes", ["avaliavel_type"], name: "index_avaliacoes_on_avaliavel_type", using: :btree
  add_index "avaliacoes", ["user_id"], name: "avaliacoes_user_id_fk", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "commentable_id",   default: 0
    t.string   "commentable_type", default: ""
    t.string   "title",            default: ""
    t.text     "body"
    t.string   "subject",          default: ""
    t.integer  "user_id",          default: 0,  null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["parent_id"], name: "comments_parent_id_fk", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "commontator_comments", force: true do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                      null: false
    t.text     "body",                           null: false
    t.datetime "deleted_at"
    t.integer  "cached_votes_total", default: 0
    t.integer  "cached_votes_up",    default: 0
    t.integer  "cached_votes_down",  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_comments", ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down", using: :btree
  add_index "commontator_comments", ["cached_votes_total"], name: "index_commontator_comments_on_cached_votes_total", using: :btree
  add_index "commontator_comments", ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up", using: :btree
  add_index "commontator_comments", ["creator_type", "creator_id", "thread_id"], name: "index_c_c_on_c_type_and_c_id_and_t_id", using: :btree
  add_index "commontator_comments", ["thread_id"], name: "index_commontator_comments_on_thread_id", using: :btree

  create_table "commontator_subscriptions", force: true do |t|
    t.string   "subscriber_type",             null: false
    t.integer  "subscriber_id",               null: false
    t.integer  "thread_id",                   null: false
    t.integer  "unread",          default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_subscriptions", ["subscriber_type", "subscriber_id", "thread_id"], name: "index_c_s_on_s_type_and_s_id_and_t_id", unique: true, using: :btree
  add_index "commontator_subscriptions", ["thread_id"], name: "index_commontator_subscriptions_on_thread_id", using: :btree

  create_table "commontator_threads", force: true do |t|
    t.string   "commontable_type"
    t.integer  "commontable_id"
    t.datetime "closed_at"
    t.string   "closer_type"
    t.integer  "closer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_threads", ["commontable_type", "commontable_id"], name: "index_c_t_on_c_type_and_c_id", unique: true, using: :btree

  create_table "episodios", force: true do |t|
    t.integer  "numero",                             default: 0, null: false
    t.integer  "temporada",                          default: 0, null: false
    t.integer  "serie_id",                           default: 0, null: false
    t.string   "nome"
    t.string   "diretor"
    t.string   "banner"
    t.string   "id_imdb"
    t.text     "sinopse",           limit: 16777215
    t.text     "atores_convidados", limit: 16777215
    t.integer  "numero_absoluto"
    t.string   "nota"
    t.datetime "estreia"
    t.string   "escritores"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ativo"
  end

  add_index "episodios", ["serie_id"], name: "episodios_serie_id_fk", using: :btree
  add_index "episodios", ["slug"], name: "index_episodios_on_slug", unique: true, using: :btree

  create_table "friendships", force: true do |t|
    t.integer "friendable_id"
    t.integer "friend_id"
    t.integer "blocker_id"
    t.boolean "pending",       default: true
  end

  add_index "friendships", ["blocker_id"], name: "friendships_blocker_id_fk", using: :btree
  add_index "friendships", ["friend_id"], name: "friendships_friend_id_fk", using: :btree
  add_index "friendships", ["friendable_id", "friend_id"], name: "index_friendships_on_friendable_id_and_friend_id", unique: true, using: :btree

  create_table "generos", force: true do |t|
    t.string   "nome",       default: "", null: false
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "generos", ["slug"], name: "index_generos_on_slug", unique: true, using: :btree

  create_table "generos_series", id: false, force: true do |t|
    t.integer "serie_id"
    t.integer "genero_id"
  end

  add_index "generos_series", ["genero_id"], name: "generos_series_genero_id_fk", using: :btree
  add_index "generos_series", ["serie_id"], name: "generos_series_serie_id_fk", using: :btree

  create_table "personagens", force: true do |t|
    t.string   "imagem"
    t.string   "nome",       default: "", null: false
    t.integer  "serie_id"
    t.integer  "aparicao"
    t.integer  "ator_id",    default: 0,  null: false
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "personagens", ["ator_id"], name: "personagens_ator_id_fk", using: :btree
  add_index "personagens", ["serie_id"], name: "personagens_serie_id_fk", using: :btree
  add_index "personagens", ["slug"], name: "index_personagens_on_slug", unique: true, using: :btree

  create_table "produtoras", force: true do |t|
    t.string   "nome",       default: "", null: false
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "produtoras", ["slug"], name: "index_produtoras_on_slug", unique: true, using: :btree

  create_table "series", force: true do |t|
    t.string   "nome",                              default: "", null: false
    t.string   "dia_exibicao"
    t.string   "horario_exibicao"
    t.string   "banner"
    t.string   "fanart"
    t.datetime "estreia"
    t.string   "id_imdb"
    t.text     "sinopse",          limit: 16777215
    t.string   "nota"
    t.integer  "duracao_episodio"
    t.string   "status"
    t.string   "poster"
    t.integer  "produtora_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "trailer"
  end

  add_index "series", ["nome"], name: "index_series_on_nome", unique: true, using: :btree
  add_index "series", ["produtora_id"], name: "series_produtora_id_fk", using: :btree
  add_index "series", ["slug"], name: "index_series_on_slug", unique: true, using: :btree

  create_table "temporadas", force: true do |t|
    t.string   "imagem"
    t.integer  "serie_id"
    t.integer  "temporada"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "temporadas", ["serie_id"], name: "temporadas_serie_id_fk", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",                                 null: false
    t.string   "encrypted_password",     default: "",                                 null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "slug"
    t.string   "imagem",                 default: "/images/series/imagem_padrao.jpg"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  add_foreign_key "acompanhamento_series", "avaliacoes", name: "acompanhamento_series_avaliacao_id_fk"

  add_foreign_key "avaliacoes", "users", name: "avaliacoes_user_id_fk"

  add_foreign_key "comments", "comments", name: "comments_parent_id_fk", column: "parent_id"
  add_foreign_key "comments", "users", name: "comments_user_id_fk"

  add_foreign_key "episodios", "series", name: "episodios_serie_id_fk"

  add_foreign_key "friendships", "users", name: "friendships_blocker_id_fk", column: "blocker_id"
  add_foreign_key "friendships", "users", name: "friendships_friend_id_fk", column: "friend_id"
  add_foreign_key "friendships", "users", name: "friendships_friendable_id_fk", column: "friendable_id"

  add_foreign_key "generos_series", "generos", name: "generos_series_genero_id_fk"
  add_foreign_key "generos_series", "series", name: "generos_series_serie_id_fk"

  add_foreign_key "personagens", "atores", name: "personagens_ator_id_fk"
  add_foreign_key "personagens", "series", name: "personagens_serie_id_fk"

  add_foreign_key "series", "produtoras", name: "series_produtora_id_fk"

  add_foreign_key "temporadas", "series", name: "temporadas_serie_id_fk"

end
