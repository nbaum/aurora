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

ActiveRecord::Schema.define(version: 20161207215054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.decimal  "balance"
    t.integer  "tariff_id"
    t.integer  "zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["tariff_id"], name: "index_accounts_on_tariff_id", using: :btree
  add_index "accounts", ["zone_id"], name: "index_accounts_on_zone_id", using: :btree

  create_table "addresses", force: true do |t|
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

  create_table "addresses_networks", force: true do |t|
    t.string   "attachment"
    t.integer  "server_id"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses_networks", ["network_id"], name: "index_addresses_networks_on_network_id", using: :btree
  add_index "addresses_networks", ["server_id"], name: "index_addresses_networks_on_server_id", using: :btree

  create_table "appliances", force: true do |t|
    t.string   "name"
    t.string   "internal_class"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appliances", ["template_id"], name: "index_appliances_on_template_id", using: :btree

  create_table "bundles", force: true do |t|
    t.string   "name"
    t.datetime "published_at"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bundles", ["account_id"], name: "index_bundles_on_account_id", using: :btree

  create_table "errors", force: true do |t|
    t.string   "usable_type"
    t.integer  "usable_id"
    t.text     "class_name"
    t.text     "message"
    t.text     "trace"
    t.text     "target_url"
    t.text     "referer_url"
    t.text     "params"
    t.text     "user_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hosts", force: true do |t|
    t.string   "name"
    t.integer  "cores"
    t.integer  "memory"
    t.boolean  "has_storage"
    t.string   "url"
    t.inet     "address"
    t.boolean  "has_compute"
    t.integer  "zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",     default: true
  end

  add_index "hosts", ["zone_id"], name: "index_hosts_on_zone_id", using: :btree

  create_table "jobs", force: true do |t|
    t.string   "type"
    t.string   "status"
    t.json     "args",        default: {}
    t.json     "state",       default: {}
    t.integer  "owner_id"
    t.integer  "server_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "target_id"
    t.string   "target_type"
  end

  add_index "jobs", ["owner_id"], name: "index_jobs_on_owner_id", using: :btree
  add_index "jobs", ["server_id"], name: "index_jobs_on_server_id", using: :btree

  create_table "networks", force: true do |t|
    t.string   "name"
    t.string   "bridge"
    t.string   "gateway"
    t.integer  "prefix"
    t.inet     "first"
    t.inet     "last"
    t.integer  "account_id"
    t.integer  "bundle_id"
    t.integer  "zone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "index"
  end

  add_index "networks", ["account_id"], name: "index_networks_on_account_id", using: :btree
  add_index "networks", ["bundle_id"], name: "index_networks_on_bundle_id", using: :btree
  add_index "networks", ["zone_id"], name: "index_networks_on_zone_id", using: :btree

  create_table "servers", force: true do |t|
    t.string   "name"
    t.integer  "cores"
    t.integer  "memory"
    t.integer  "storage"
    t.string   "password"
    t.string   "state"
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
    t.string   "machine_type"
    t.string   "boot_order"
    t.boolean  "pinned",         default: false
    t.boolean  "is_template",    default: false
    t.text     "notes"
  end

  add_index "servers", ["account_id"], name: "index_servers_on_account_id", using: :btree
  add_index "servers", ["appliance_id"], name: "index_servers_on_appliance_id", using: :btree
  add_index "servers", ["base_id"], name: "index_servers_on_base_id", using: :btree
  add_index "servers", ["bundle_id"], name: "index_servers_on_bundle_id", using: :btree
  add_index "servers", ["current_id"], name: "index_servers_on_current_id", using: :btree
  add_index "servers", ["host_id"], name: "index_servers_on_host_id", using: :btree
  add_index "servers", ["template_id"], name: "index_servers_on_template_id", using: :btree
  add_index "servers", ["zone_id"], name: "index_servers_on_zone_id", using: :btree

  create_table "servers_volumes", force: true do |t|
    t.string   "attachment"
    t.integer  "server_id"
    t.integer  "volume_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "servers_volumes", ["server_id"], name: "index_servers_volumes_on_server_id", using: :btree
  add_index "servers_volumes", ["volume_id"], name: "index_servers_volumes_on_volume_id", using: :btree

  create_table "sessions", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "storage_pools", force: true do |t|
    t.string   "name"
    t.integer  "size",       limit: 8
    t.integer  "account_id"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "path"
  end

  add_index "storage_pools", ["account_id"], name: "index_storage_pools_on_account_id", using: :btree
  add_index "storage_pools", ["host_id"], name: "index_storage_pools_on_host_id", using: :btree

  create_table "subnets", force: true do |t|
    t.string   "kind"
    t.string   "prefix"
    t.inet     "gateway"
    t.inet     "first"
    t.inet     "last"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subnets", ["network_id"], name: "index_subnets_on_network_id", using: :btree

  create_table "tariffs", force: true do |t|
    t.boolean  "default"
    t.string   "name"
    t.decimal  "core"
    t.decimal  "memory"
    t.decimal  "storage"
    t.decimal  "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.decimal  "rate"
    t.string   "description"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "period"
    t.string   "kind"
    t.datetime "closed_at"
  end

  add_index "transactions", ["account_id"], name: "index_transactions_on_account_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.integer  "account_id"
    t.boolean  "administrator"
    t.text     "ssh_keys"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree

  create_table "volumes", force: true do |t|
    t.string   "name"
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
    t.string   "path"
  end

  add_index "volumes", ["account_id"], name: "index_volumes_on_account_id", using: :btree
  add_index "volumes", ["base_id"], name: "index_volumes_on_base_id", using: :btree
  add_index "volumes", ["bundle_id"], name: "index_volumes_on_bundle_id", using: :btree
  add_index "volumes", ["server_id"], name: "index_volumes_on_server_id", using: :btree
  add_index "volumes", ["storage_pool_id"], name: "index_volumes_on_storage_pool_id", using: :btree

  create_table "zones", force: true do |t|
    t.string   "name"
    t.string   "dns1"
    t.string   "dns2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pretend",     default: false
    t.integer  "reliability", default: 0
  end

end
