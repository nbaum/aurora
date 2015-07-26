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

ActiveRecord::Schema.define(version: 20150726125231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.decimal  "balance"
    t.integer  "tariff_id"
    t.integer  "zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["tariff_id"], name: "index_accounts_on_tariff_id", using: :btree
  add_index "accounts", ["zone_id"], name: "index_accounts_on_zone_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.inet     "ip"
    t.integer  "account_id"
    t.integer  "server_id"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subnet_id"
  end

  add_index "addresses", ["account_id"], name: "index_addresses_on_account_id", using: :btree
  add_index "addresses", ["network_id"], name: "index_addresses_on_network_id", using: :btree
  add_index "addresses", ["server_id"], name: "index_addresses_on_server_id", using: :btree
  add_index "addresses", ["subnet_id"], name: "index_addresses_on_subnet_id", using: :btree

  create_table "addresses_networks", force: :cascade do |t|
    t.string   "attachment", limit: 255
    t.integer  "server_id"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses_networks", ["network_id"], name: "index_addresses_networks_on_network_id", using: :btree
  add_index "addresses_networks", ["server_id"], name: "index_addresses_networks_on_server_id", using: :btree

  create_table "appliances", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "internal_class", limit: 255
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appliances", ["template_id"], name: "index_appliances_on_template_id", using: :btree

  create_table "bundles", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "published_at"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bundles", ["account_id"], name: "index_bundles_on_account_id", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "snippet_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaigns", ["account_id"], name: "index_campaigns_on_account_id", using: :btree
  add_index "campaigns", ["snippet_id"], name: "index_campaigns_on_snippet_id", using: :btree

  create_table "data_sources", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "data_sources", ["account_id"], name: "index_data_sources_on_account_id", using: :btree

  create_table "hosts", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "cores"
    t.integer  "memory",      limit: 8
    t.string   "url",         limit: 255
    t.inet     "address"
    t.boolean  "has_compute"
    t.integer  "zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_storage"
    t.boolean  "enabled",                 default: true
  end

  add_index "hosts", ["zone_id"], name: "index_hosts_on_zone_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "type"
    t.string   "status"
    t.jsonb    "args",        default: {}
    t.jsonb    "state",       default: {}
    t.integer  "owner_id"
    t.integer  "server_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jobs", ["owner_id"], name: "index_jobs_on_owner_id", using: :btree
  add_index "jobs", ["server_id"], name: "index_jobs_on_server_id", using: :btree

  create_table "networks", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "bridge",     limit: 255
    t.string   "gateway",    limit: 255
    t.integer  "prefix"
    t.inet     "first"
    t.inet     "last"
    t.integer  "account_id"
    t.integer  "bundle_id"
    t.integer  "zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "networks", ["account_id"], name: "index_networks_on_account_id", using: :btree
  add_index "networks", ["bundle_id"], name: "index_networks_on_bundle_id", using: :btree
  add_index "networks", ["zone_id"], name: "index_networks_on_zone_id", using: :btree

  create_table "servers", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "cores"
    t.integer  "memory"
    t.integer  "storage"
    t.string   "password",       limit: 255
    t.string   "state",          limit: 255
    t.integer  "affinity_group"
    t.json     "appliance_data"
    t.integer  "template_id"
    t.integer  "host_id"
    t.integer  "account_id"
    t.integer  "zone_id"
    t.integer  "appliance_id"
    t.integer  "bundle_id"
    t.datetime "published_at"
    t.integer  "base_id"
    t.integer  "current_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "machine_type",   limit: 255
    t.string   "boot_order",     limit: 255
    t.boolean  "pinned",                     default: false
  end

  add_index "servers", ["account_id"], name: "index_servers_on_account_id", using: :btree
  add_index "servers", ["appliance_id"], name: "index_servers_on_appliance_id", using: :btree
  add_index "servers", ["base_id"], name: "index_servers_on_base_id", using: :btree
  add_index "servers", ["bundle_id"], name: "index_servers_on_bundle_id", using: :btree
  add_index "servers", ["current_id"], name: "index_servers_on_current_id", using: :btree
  add_index "servers", ["host_id"], name: "index_servers_on_host_id", using: :btree
  add_index "servers", ["template_id"], name: "index_servers_on_template_id", using: :btree
  add_index "servers", ["zone_id"], name: "index_servers_on_zone_id", using: :btree

  create_table "servers_volumes", force: :cascade do |t|
    t.string   "attachment", limit: 255
    t.integer  "server_id"
    t.integer  "volume_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "servers_volumes", ["server_id"], name: "index_servers_volumes_on_server_id", using: :btree
  add_index "servers_volumes", ["volume_id"], name: "index_servers_volumes_on_volume_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snippets", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "html"
    t.text     "css"
    t.text     "plain"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "snippets", ["account_id"], name: "index_snippets_on_account_id", using: :btree

  create_table "storage_pools", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "size",       limit: 8
    t.integer  "account_id"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "path",       limit: 255
  end

  add_index "storage_pools", ["account_id"], name: "index_storage_pools_on_account_id", using: :btree
  add_index "storage_pools", ["host_id"], name: "index_storage_pools_on_host_id", using: :btree

  create_table "subnets", force: :cascade do |t|
    t.string   "kind",       limit: 255
    t.string   "prefix",     limit: 255
    t.inet     "gateway"
    t.inet     "first"
    t.inet     "last"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subnets", ["network_id"], name: "index_subnets_on_network_id", using: :btree

  create_table "tariffs", force: :cascade do |t|
    t.boolean  "default"
    t.string   "name",       limit: 255
    t.decimal  "core"
    t.decimal  "memory"
    t.decimal  "storage"
    t.decimal  "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal  "amount"
    t.string   "description", limit: 255
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["account_id"], name: "index_transactions_on_account_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.integer  "account_id"
    t.boolean  "administrator"
    t.text     "ssh_keys"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree

  create_table "volumes", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "size",            limit: 8
    t.boolean  "ephemeral"
    t.boolean  "optical"
    t.integer  "server_id"
    t.integer  "base_id"
    t.integer  "account_id"
    t.integer  "bundle_id"
    t.integer  "storage_pool_id"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "path",            limit: 255
  end

  add_index "volumes", ["account_id"], name: "index_volumes_on_account_id", using: :btree
  add_index "volumes", ["base_id"], name: "index_volumes_on_base_id", using: :btree
  add_index "volumes", ["bundle_id"], name: "index_volumes_on_bundle_id", using: :btree
  add_index "volumes", ["server_id"], name: "index_volumes_on_server_id", using: :btree
  add_index "volumes", ["storage_pool_id"], name: "index_volumes_on_storage_pool_id", using: :btree

  create_table "zones", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "dns1",        limit: 255
    t.string   "dns2",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pretend",                 default: false
    t.integer  "reliability",             default: 0
  end

end
