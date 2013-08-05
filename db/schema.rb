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

ActiveRecord::Schema.define(version: 20130731013517) do

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

  create_table "episodios", force: true do |t|
    t.integer  "numero",                             default: 0, null: false
    t.integer  "temporada",                          default: 0, null: false
    t.integer  "serie_id",                           default: 0, null: false
    t.string   "nome"
    t.string   "diretor"
    t.string   "banner"
    t.string   "id_imdb"
    t.text     "sinopse",           limit: 16777215
    t.string   "atores_convidados"
    t.integer  "numero_absoluto"
    t.string   "nota"
    t.datetime "estreia"
    t.string   "escritores"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "episodios", ["serie_id"], name: "episodios_serie_id_fk", using: :btree
  add_index "episodios", ["slug"], name: "index_episodios_on_slug", unique: true, using: :btree

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
  add_index "temporadas", ["slug"], name: "index_temporadas_on_slug", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",                                   null: false
    t.string   "encrypted_password",     default: "",                                   null: false
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
    t.string   "imagem",                 default: "../assets/series/imagem_padrao.jpg"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  add_foreign_key "avaliacoes", "users", :name => "avaliacoes_user_id_fk"

  add_foreign_key "episodios", "series", :name => "episodios_serie_id_fk"

  add_foreign_key "generos_series", "generos", :name => "generos_series_genero_id_fk"
  add_foreign_key "generos_series", "series", :name => "generos_series_serie_id_fk"

  add_foreign_key "personagens", "atores", :name => "personagens_ator_id_fk"
  add_foreign_key "personagens", "series", :name => "personagens_serie_id_fk"

  add_foreign_key "series", "produtoras", :name => "series_produtora_id_fk"

  add_foreign_key "temporadas", "series", :name => "temporadas_serie_id_fk"

end
