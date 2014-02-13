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

ActiveRecord::Schema.define(version: 20140212180901) do

  create_table "itps_accounts", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
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
  end

  add_index "itps_accounts", ["email"], name: "index_itps_accounts_on_email", unique: true, using: :btree
  add_index "itps_accounts", ["reset_password_token"], name: "index_itps_accounts_on_reset_password_token", unique: true, using: :btree

  create_table "itps_accounts_roles", force: true do |t|
    t.string   "role_name",  null: false
    t.integer  "account_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "itps_documentations", force: true do |t|
    t.string   "permalink",  null: false
    t.string   "title",      null: false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "itps_documentations", ["permalink"], name: "index_itps_documentations_on_permalink", using: :btree

  create_table "itps_documentations_tags", force: true do |t|
    t.integer  "documentation_id",             null: false
    t.integer  "tag_id",                       null: false
    t.integer  "count",            default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "itps_documentations_tags", ["documentation_id"], name: "index_itps_documentations_tags_on_documentation_id", using: :btree
  add_index "itps_documentations_tags", ["tag_id"], name: "index_itps_documentations_tags_on_tag_id", using: :btree

  create_table "itps_email_archives", force: true do |t|
    t.string   "mailer_name",   null: false
    t.string   "mailer_method", null: false
    t.string   "destination",   null: false
    t.string   "origination"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "itps_email_archives", ["destination"], name: "index_itps_email_archives_on_destination", using: :btree

  create_table "itps_email_archives_serialized_objects", force: true do |t|
    t.integer "email_archive_id",              null: false
    t.integer "order_number",      default: 0, null: false
    t.string  "name_of_model",                 null: false
    t.string  "variable_namekey",              null: false
    t.string  "external_model_id",             null: false
  end

  add_index "itps_email_archives_serialized_objects", ["email_archive_id"], name: "index_itps_email_archives_serialized_objects_on_email_archive_id", using: :btree

  create_table "itps_escrows", force: true do |t|
    t.integer  "service_party_id",                                  null: false
    t.integer  "payment_party_id",                                  null: false
    t.integer  "draft_party_id",                                    null: false
    t.string   "permalink",                                         null: false
    t.string   "status_key"
    t.datetime "completed_at"
    t.datetime "deleted_at"
    t.datetime "payment_party_agreed_at"
    t.datetime "serviced_party_agreed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payment_party_agree_key"
    t.string   "service_party_agree_key"
    t.decimal  "dollar_amount",            precision: 16, scale: 2
    t.datetime "claimed_at"
  end

  add_index "itps_escrows", ["draft_party_id"], name: "index_itps_escrows_on_draft_party_id", using: :btree
  add_index "itps_escrows", ["payment_party_agree_key"], name: "index_itps_escrows_on_payment_party_agree_key", unique: true, using: :btree
  add_index "itps_escrows", ["payment_party_id"], name: "index_itps_escrows_on_payment_party_id", using: :btree
  add_index "itps_escrows", ["permalink"], name: "index_itps_escrows_on_permalink", unique: true, using: :btree
  add_index "itps_escrows", ["service_party_agree_key"], name: "index_itps_escrows_on_service_party_agree_key", unique: true, using: :btree
  add_index "itps_escrows", ["service_party_id"], name: "index_itps_escrows_on_service_party_id", using: :btree

  create_table "itps_escrows_documents", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "permalink",                  null: false
    t.datetime "approved_at"
    t.datetime "rejected_at"
    t.integer  "step_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attached_file_file_name"
    t.string   "attached_file_content_type"
    t.integer  "attached_file_file_size"
    t.datetime "attached_file_updated_at"
  end

  add_index "itps_escrows_documents", ["permalink"], name: "index_itps_escrows_documents_on_permalink", unique: true, using: :btree
  add_index "itps_escrows_documents", ["step_id"], name: "index_itps_escrows_documents_on_step_id", using: :btree

  create_table "itps_escrows_steps", force: true do |t|
    t.integer  "escrow_id",                null: false
    t.string   "title",                    null: false
    t.string   "permalink",                null: false
    t.text     "instructions",             null: false
    t.datetime "completed_at"
    t.integer  "position",     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "previous_id"
    t.string   "class_name"
  end

  add_index "itps_escrows_steps", ["escrow_id"], name: "index_itps_escrows_steps_on_escrow_id", using: :btree
  add_index "itps_escrows_steps", ["permalink"], name: "index_itps_escrows_steps_on_permalink", unique: true, using: :btree
  add_index "itps_escrows_steps", ["previous_id"], name: "index_itps_escrows_steps_on_previous_id", using: :btree

  create_table "itps_money_transfers", force: true do |t|
    t.integer  "bank_account_id"
    t.decimal  "dollar_amount",   precision: 16, scale: 2
    t.boolean  "inbound",                                  default: true, null: false
    t.string   "memo"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bank_name"
    t.string   "name_on_account"
    t.datetime "claimed_at"
  end

  add_index "itps_money_transfers", ["bank_account_id"], name: "index_itps_money_transfers_on_bank_account_id", using: :btree

  create_table "itps_money_transfers_escrows", force: true do |t|
    t.integer  "money_transfer_id"
    t.integer  "escrow_id"
    t.string   "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "itps_money_transfers_escrows", ["escrow_id"], name: "index_itps_money_transfers_escrows_on_escrow_id", using: :btree
  add_index "itps_money_transfers_escrows", ["money_transfer_id"], name: "index_itps_money_transfers_escrows_on_money_transfer_id", using: :btree

  create_table "itps_parties", force: true do |t|
    t.string   "company_name"
    t.string   "email",        null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink",    null: false
  end

  add_index "itps_parties", ["email"], name: "index_itps_parties_on_email", unique: true, using: :btree
  add_index "itps_parties", ["permalink"], name: "index_itps_parties_on_permalink", unique: true, using: :btree

  create_table "itps_parties_bank_accounts", force: true do |t|
    t.string   "account_number", null: false
    t.string   "routing_number", null: false
    t.integer  "party_id"
    t.datetime "deleted_at"
    t.datetime "expires_at"
    t.datetime "defaulted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "itps_parties_bank_accounts", ["party_id"], name: "index_itps_parties_bank_accounts_on_party_id", using: :btree

  create_table "itps_tags", force: true do |t|
    t.string "permalink",    null: false
    t.string "presentation", null: false
  end

  add_index "itps_tags", ["permalink"], name: "index_itps_tags_on_permalink", unique: true, using: :btree

  create_table "itps_tags_tags", force: true do |t|
    t.integer  "parent_id",              null: false
    t.integer  "child_id",               null: false
    t.integer  "count",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "itps_tags_tags", ["child_id"], name: "index_itps_tags_tags_on_child_id", using: :btree
  add_index "itps_tags_tags", ["parent_id", "child_id"], name: "index_itps_tags_tags_on_parent_id_and_child_id", unique: true, using: :btree

  create_table "logistica_plans", force: true do |t|
    t.string   "plan_type",             null: false
    t.string   "external_reference_id"
    t.text     "notes"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "ready_at"
  end

  create_table "logistica_plans_planners", force: true do |t|
    t.integer "plan_id"
    t.integer "planner_id"
    t.string  "planner_type"
    t.string  "role"
  end

  add_index "logistica_plans_planners", ["plan_id"], name: "index_logistica_plans_planners_on_plan_id", using: :btree
  add_index "logistica_plans_planners", ["planner_id", "planner_type"], name: "index_logistica_plans_planners_on_planner_id_and_planner_type", using: :btree

  create_table "logistica_proofs", force: true do |t|
    t.integer  "step_id"
    t.integer  "provable_id"
    t.string   "provable_type"
    t.string   "title"
    t.string   "permalink"
    t.datetime "expires_at"
    t.datetime "rejected_at"
    t.datetime "approved_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logistica_proofs", ["step_id"], name: "index_logistica_proofs_on_step_id", using: :btree

  create_table "logistica_steps", force: true do |t|
    t.integer  "plan_id"
    t.string   "presentation"
    t.string   "permalink"
    t.string   "step_type",                null: false
    t.integer  "position",     default: 0, null: false
    t.text     "notes"
    t.datetime "expires_at"
    t.datetime "rejected_at"
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logistica_steps", ["plan_id"], name: "index_logistica_steps_on_plan_id", using: :btree

  create_table "logistica_steps_overseers", force: true do |t|
    t.integer "step_id"
    t.integer "overseer_id"
    t.string  "overseer_type"
    t.string  "role"
  end

  add_index "logistica_steps_overseers", ["overseer_id", "overseer_type"], name: "index_logistica_steps_overseers_on_overseer_id_and_overseer_type", using: :btree
  add_index "logistica_steps_overseers", ["step_id"], name: "index_logistica_steps_overseers_on_step_id", using: :btree

  create_table "spree_addresses", force: true do |t|
    t.string   "fullname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city_permalink"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "alternative_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nickname"
  end

  add_index "spree_addresses", ["city_permalink"], name: "index_spree_addresses_on_city_permalink", using: :btree
  add_index "spree_addresses", ["fullname"], name: "index_addresses_on_fullname", using: :btree

  create_table "spree_assets", force: true do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_file_size"
    t.integer  "position"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.string   "type",                    limit: 75
    t.datetime "attachment_updated_at"
    t.text     "alt"
  end

  add_index "spree_assets", ["viewable_id"], name: "index_assets_on_viewable_id", using: :btree
  add_index "spree_assets", ["viewable_type", "type"], name: "index_assets_on_viewable_type_and_type", using: :btree

  create_table "spree_cities", force: true do |t|
    t.integer  "state_id"
    t.string   "romanized_name",     null: false
    t.string   "permalink",          null: false
    t.string   "local_presentation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_cities", ["permalink"], name: "index_spree_cities_on_permalink", unique: true, using: :btree
  add_index "spree_cities", ["state_id"], name: "index_spree_cities_on_state_id", using: :btree

  create_table "spree_comments", force: true do |t|
    t.integer  "offer_id"
    t.integer  "shop_id"
    t.text     "content",    null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_countries", force: true do |t|
    t.string   "iso"
    t.string   "iso3"
    t.string   "permalink",          null: false
    t.string   "romanized_name"
    t.string   "local_presentation"
    t.string   "numcode"
    t.datetime "updated_at"
  end

  add_index "spree_countries", ["permalink"], name: "index_spree_countries_on_permalink", unique: true, using: :btree

  create_table "spree_dispute_negotiations", force: true do |t|
    t.integer  "shop_id"
    t.integer  "post_transaction_id"
    t.integer  "amount"
    t.text     "comment"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_dispute_negotiations", ["post_transaction_id"], name: "index_spree_dispute_negotiations_on_post_transaction_id", using: :btree
  add_index "spree_dispute_negotiations", ["shop_id"], name: "index_spree_dispute_negotiations_on_shop_id", using: :btree

  create_table "spree_documents", force: true do |t|
    t.string   "presentation"
    t.string   "permalink",                  null: false
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.datetime "rejected_at"
    t.string   "comment"
    t.string   "documentation_file_name"
    t.string   "documentation_content_type"
    t.integer  "documentation_file_size"
    t.datetime "documentation_updated_at"
    t.datetime "expires_at"
    t.datetime "approved_at"
  end

  add_index "spree_documents", ["documentable_id", "documentable_type"], name: "index_spree_documents_on_documentable_id_and_documentable_type", using: :btree
  add_index "spree_documents", ["permalink"], name: "index_spree_documents_on_permalink", using: :btree

  create_table "spree_escrow_steps", force: true do |t|
    t.string   "presentation"
    t.string   "permalink",       null: false
    t.integer  "finalization_id"
    t.datetime "completed_at"
    t.string   "step_type",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_escrow_steps", ["finalization_id"], name: "index_spree_escrow_steps_on_finalization_id", using: :btree
  add_index "spree_escrow_steps", ["permalink"], name: "index_spree_escrow_steps_on_permalink", using: :btree

  create_table "spree_finalizations", force: true do |t|
    t.integer  "offer_id"
    t.datetime "expires_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_finalizations", ["offer_id"], name: "index_spree_finalizations_on_offer_id", using: :btree

  create_table "spree_listings", force: true do |t|
    t.integer  "stockpile_id",          null: false
    t.integer  "shop_id"
    t.integer  "days_to_refresh"
    t.datetime "available_on"
    t.datetime "expires_on"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "packing_weight_pounds"
  end

  add_index "spree_listings", ["stockpile_id"], name: "index_spree_listings_on_stockpile_id", unique: true, using: :btree

  create_table "spree_materials", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "permalink",   null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_materials", ["permalink"], name: "index_spree_materials_on_permalink", unique: true, using: :btree

  create_table "spree_offers", force: true do |t|
    t.integer  "shop_id"
    t.integer  "listing_id"
    t.integer  "address_id"
    t.decimal  "usd_per_pound",           precision: 10, scale: 5, default: 0.0,         null: false
    t.integer  "loads"
    t.string   "shipping_terms",                                   default: "EXWORKS",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.datetime "expires_at"
    t.string   "transport_method",                                 default: "CONTAINER", null: false
    t.integer  "minimum_pounds_per_load"
    t.datetime "confirmed_at"
  end

  add_index "spree_offers", ["listing_id"], name: "index_spree_offers_on_listing_id", using: :btree
  add_index "spree_offers", ["shop_id"], name: "index_spree_offers_on_shop_id", using: :btree

  create_table "spree_option_types", force: true do |t|
    t.string   "name",         limit: 100
    t.string   "presentation", limit: 100
    t.integer  "position",                 default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_option_values", force: true do |t|
    t.integer  "position"
    t.string   "name"
    t.string   "presentation"
    t.integer  "option_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_option_values_stockpiles", force: true do |t|
    t.integer "option_value_id"
    t.integer "stockpile_id"
  end

  add_index "spree_option_values_stockpiles", ["option_value_id"], name: "index_spree_option_values_stockpiles_on_option_value_id", using: :btree
  add_index "spree_option_values_stockpiles", ["stockpile_id"], name: "index_spree_option_values_stockpiles_on_stockpile_id", using: :btree

  create_table "spree_origin_products", force: true do |t|
    t.string   "permalink",    null: false
    t.string   "presentation", null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_origin_products", ["permalink"], name: "index_spree_origin_products_on_permalink", unique: true, using: :btree

  create_table "spree_origin_products_stockpiles", force: true do |t|
    t.integer "origin_product_id", null: false
    t.integer "stockpile_id",      null: false
  end

  add_index "spree_origin_products_stockpiles", ["origin_product_id", "stockpile_id"], name: "indx_ops_opid_sid", unique: true, using: :btree
  add_index "spree_origin_products_stockpiles", ["stockpile_id"], name: "index_spree_origin_products_stockpiles_on_stockpile_id", using: :btree

  create_table "spree_post_transactions", force: true do |t|
    t.integer  "finalization_id"
    t.datetime "closed_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_post_transactions", ["finalization_id"], name: "index_spree_post_transactions_on_finalization_id", using: :btree

  create_table "spree_preferences", force: true do |t|
    t.string   "name",       limit: 100
    t.integer  "owner_id"
    t.string   "owner_type"
    t.text     "value"
    t.string   "key"
    t.string   "value_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_preferences", ["key"], name: "index_spree_preferences_on_key", unique: true, using: :btree

  create_table "spree_ratings", force: true do |t|
    t.integer  "trustworthiness", null: false
    t.integer  "simplicity",      null: false
    t.integer  "agreeability",    null: false
    t.text     "notes"
    t.integer  "shop_id"
    t.integer  "reviewer_id"
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_ratings", ["reviewable_id", "reviewable_type"], name: "index_spree_ratings_on_reviewable_id_and_reviewable_type", using: :btree
  add_index "spree_ratings", ["reviewer_id"], name: "index_spree_ratings_on_reviewer_id", using: :btree
  add_index "spree_ratings", ["shop_id"], name: "index_spree_ratings_on_shop_id", using: :btree

  create_table "spree_seaports", force: true do |t|
    t.string  "port_code",  null: false
    t.string  "port_name"
    t.integer "address_id"
  end

  add_index "spree_seaports", ["address_id"], name: "index_spree_seaports_on_address_id", using: :btree
  add_index "spree_seaports", ["port_code"], name: "index_spree_seaports_on_port_code", unique: true, using: :btree

  create_table "spree_service_contracts", force: true do |t|
    t.integer "finalization_id"
    t.integer "shop_id"
    t.integer "serviceable_id"
    t.string  "serviceable_type"
  end

  add_index "spree_service_contracts", ["finalization_id"], name: "index_spree_service_contracts_on_finalization_id", using: :btree
  add_index "spree_service_contracts", ["serviceable_id", "serviceable_type"], name: "idx_contracts_sid_stype", using: :btree
  add_index "spree_service_contracts", ["shop_id"], name: "index_spree_service_contracts_on_shop_id", using: :btree

  create_table "spree_service_demands", force: true do |t|
    t.integer  "finalization_id"
    t.integer  "serviceable_id"
    t.string   "serviceable_type"
    t.datetime "fulfilled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_service_demands", ["finalization_id"], name: "index_spree_service_demands_on_finalization_id", using: :btree
  add_index "spree_service_demands", ["serviceable_id", "serviceable_type"], name: "idx_demands_sid_and_stype", using: :btree

  create_table "spree_service_supplies", force: true do |t|
    t.integer  "shop_id"
    t.integer  "serviceable_id"
    t.string   "serviceable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_service_supplies", ["serviceable_id", "serviceable_type"], name: "idx_supplies_sid_and_stype", using: :btree
  add_index "spree_service_supplies", ["shop_id"], name: "index_spree_service_supplies_on_shop_id", using: :btree

  create_table "spree_serviceables_escrows", force: true do |t|
    t.datetime "buyer_paid_at"
    t.datetime "buyer_received_at"
    t.datetime "seller_shipped_at"
    t.datetime "seller_paid_at"
    t.string   "external_id"
    t.string   "external_type"
    t.integer  "payment_amount",    null: false
    t.datetime "cancelled_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_serviceables_inspections", force: true do |t|
    t.datetime "inspected_at"
    t.decimal  "usd_price",    precision: 10, scale: 0
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_serviceables_ships", force: true do |t|
    t.integer  "start_port_id",                                             null: false
    t.string   "start_terminal_code"
    t.integer  "finish_port_id",                                            null: false
    t.string   "finish_terminal_code"
    t.string   "carrier_name"
    t.string   "vessel_id"
    t.datetime "depart_at"
    t.datetime "arrive_at"
    t.datetime "cutoff_at"
    t.datetime "pull_at"
    t.datetime "return_at"
    t.datetime "lategate_at"
    t.integer  "containers",                                    default: 1, null: false
    t.decimal  "usd_price",            precision: 10, scale: 2
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_serviceables_ships", ["finish_port_id"], name: "index_spree_serviceables_ships_on_finish_port_id", using: :btree
  add_index "spree_serviceables_ships", ["start_port_id"], name: "index_spree_serviceables_ships_on_start_port_id", using: :btree

  create_table "spree_serviceables_trucks", force: true do |t|
    t.integer  "origination_id"
    t.integer  "destination_id"
    t.datetime "pickup_at"
    t.datetime "arrive_at"
    t.decimal  "usd_price",      precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_shops", force: true do |t|
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.string   "email"
    t.integer  "address_id"
    t.string   "name",       null: false
    t.string   "permalink",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_shops", ["permalink"], name: "index_spree_shops_on_permalink", unique: true, using: :btree

  create_table "spree_states", force: true do |t|
    t.string   "romanized_name"
    t.string   "abbr"
    t.string   "permalink",          null: false
    t.string   "local_presentation"
    t.string   "country_permalink"
    t.datetime "updated_at"
  end

  add_index "spree_states", ["permalink"], name: "index_spree_states_on_permalink", unique: true, using: :btree

  create_table "spree_stockpiles", force: true do |t|
    t.integer  "material_id"
    t.integer  "address_id"
    t.integer  "pounds_on_hand"
    t.decimal  "cost_usd_per_pound", precision: 10, scale: 5
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
  end

  create_table "spree_stockpiles_taxons", force: true do |t|
    t.integer "stockpile_id"
    t.integer "taxon_id"
  end

  add_index "spree_stockpiles_taxons", ["stockpile_id"], name: "index_spree_stockpiles_taxons_on_stockpile_id", using: :btree
  add_index "spree_stockpiles_taxons", ["taxon_id"], name: "index_spree_stockpiles_taxons_on_taxon_id", using: :btree

  create_table "spree_tags", force: true do |t|
    t.string   "permalink",    null: false
    t.string   "presentation", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_tags_images", force: true do |t|
    t.integer "tag_id"
    t.integer "image_id"
  end

  add_index "spree_tags_images", ["image_id"], name: "index_spree_tags_images_on_image_id", using: :btree
  add_index "spree_tags_images", ["tag_id", "image_id"], name: "idx_on_tags_images_tag_image", unique: true, using: :btree

  create_table "spree_taxonomies", force: true do |t|
    t.string   "name",       null: false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_taxons", force: true do |t|
    t.integer  "parent_id"
    t.integer  "position",          default: 0
    t.string   "name",                          null: false
    t.string   "permalink"
    t.integer  "taxonomy_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_taxons", ["parent_id"], name: "index_taxons_on_parent_id", using: :btree
  add_index "spree_taxons", ["permalink"], name: "index_taxons_on_permalink", using: :btree
  add_index "spree_taxons", ["taxonomy_id"], name: "index_taxons_on_taxonomy_id", using: :btree

  create_table "spree_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password"
    t.string   "password_salt"
    t.string   "login"
    t.integer  "ship_address_id"
    t.integer  "bill_address_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "remember_token"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.integer  "failed_attempts",        default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "last_request_at"
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.string   "openid_identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
  end

  add_index "spree_users", ["authentication_token"], name: "index_spree_users_on_authentication_token", unique: true, using: :btree
  add_index "spree_users", ["email"], name: "index_spree_users_on_email", unique: true, using: :btree
  add_index "spree_users", ["reset_password_token"], name: "index_spree_users_on_reset_password_token", unique: true, using: :btree
  add_index "spree_users", ["shop_id"], name: "index_spree_users_on_shop_id", using: :btree
  add_index "spree_users", ["unlock_token"], name: "index_spree_users_on_unlock_token", unique: true, using: :btree

end
