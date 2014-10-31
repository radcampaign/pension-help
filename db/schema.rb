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

ActiveRecord::Schema.define(version: 20141030102754) do

  create_table "addresses", force: true do |t|
    t.integer "location_id"
    t.string  "line1"
    t.string  "line2"
    t.string  "city",           limit: 64
    t.string  "state_abbrev"
    t.string  "zip"
    t.string  "address_type"
    t.string  "legacy_code",    limit: 10
    t.string  "legacy_subcode", limit: 10
    t.string  "fmp2_code",      limit: 10
    t.decimal "latitude",                  precision: 9, scale: 6
    t.decimal "longitude",                 precision: 9, scale: 6
  end

  add_index "addresses", ["location_id"], name: "location_id", using: :btree

  create_table "agencies", force: true do |t|
    t.integer  "agency_category_id"
    t.integer  "result_type_id"
    t.string   "name"
    t.string   "name2"
    t.text     "description"
    t.string   "data_source"
    t.boolean  "is_active"
    t.string   "url"
    t.string   "url_title"
    t.string   "url2"
    t.string   "url2_title"
    t.text     "comments"
    t.text     "services_provided"
    t.boolean  "use_for_counseling"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "updated_by"
    t.string   "legacy_code",        limit: 10
    t.string   "legacy_status"
    t.string   "legacy_category1"
    t.string   "legacy_category2"
    t.string   "fmp2_code",          limit: 10
    t.string   "pha_contact_name"
    t.string   "pha_contact_title"
    t.string   "pha_contact_phone",  limit: 20
    t.string   "pha_contact_email"
  end

  add_index "agencies", ["agency_category_id"], name: "agency_category_id", using: :btree
  add_index "agencies", ["result_type_id"], name: "result_type_id", using: :btree

  create_table "agency_categories", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "assistances", force: true do |t|
    t.string "name"
  end

  create_table "assistances_partners", id: false, force: true do |t|
    t.integer "partner_id"
    t.integer "assistance_id"
  end

  add_index "assistances_partners", ["assistance_id"], name: "assistance_id", using: :btree
  add_index "assistances_partners", ["partner_id"], name: "partner_id", using: :btree

  create_table "cities", force: true do |t|
    t.string  "name"
    t.integer "county_id"
    t.string  "state_abbrev"
  end

  add_index "cities", ["county_id"], name: "county_id", using: :btree
  add_index "cities", ["name", "county_id"], name: "index_cities_on_name_and_county_id", unique: true, using: :btree

  create_table "cities_zips", id: false, force: true do |t|
    t.integer "city_id",             null: false
    t.string  "zipcode",   limit: 5, null: false
    t.string  "city_type", limit: 1
  end

  add_index "cities_zips", ["zipcode", "city_id"], name: "idx_cities_zips_on_zip_and_city", using: :btree

  create_table "claim_types", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.datetime "created_at",                               null: false
    t.integer  "commentable_id",              default: 0,  null: false
    t.string   "commentable_type", limit: 15, default: "", null: false
    t.integer  "user_id",                     default: 0,  null: false
  end

  add_index "comments", ["user_id"], name: "user_id", using: :btree

  create_table "contents", force: true do |t|
    t.string   "url"
    t.string   "title"
    t.text     "content"
    t.string   "created_at"
    t.datetime "updated_at"
    t.string   "updated_by"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.boolean  "is_active"
  end

  add_index "contents", ["parent_id"], name: "parent_id", using: :btree

  create_table "counselings", force: true do |t|
    t.string   "zipcode"
    t.date     "employment_start"
    t.date     "employment_end"
    t.boolean  "is_divorce_related"
    t.boolean  "is_survivorship_related"
    t.string   "work_state_abbrev"
    t.string   "hq_state_abbrev"
    t.string   "pension_state_abbrev"
    t.boolean  "is_over_60"
    t.decimal  "monthly_income",          precision: 10, scale: 2
    t.integer  "number_in_household"
    t.integer  "employer_type_id"
    t.integer  "federal_plan_id"
    t.integer  "military_service_id"
    t.integer  "military_branch_id"
    t.integer  "military_employer_id"
    t.integer  "pension_earner_id"
    t.string   "state_abbrev"
    t.integer  "county_id"
    t.integer  "city_id"
    t.datetime "created_at"
    t.boolean  "is_afscme_member"
    t.integer  "selected_plan_id"
    t.boolean  "currently_employed"
    t.string   "plan_name"
    t.string   "agency_name"
    t.string   "job_function"
    t.string   "feedback_email"
    t.boolean  "lost_plan"
    t.string   "behalf"
    t.string   "behalf_other"
    t.string   "gender"
    t.string   "marital_status"
    t.integer  "age"
    t.string   "ethnicity"
    t.string   "abc_path"
  end

  add_index "counselings", ["city_id"], name: "city_id", using: :btree
  add_index "counselings", ["county_id"], name: "county_id", using: :btree
  add_index "counselings", ["employer_type_id"], name: "employer_type_id", using: :btree
  add_index "counselings", ["federal_plan_id"], name: "federal_plan_id", using: :btree
  add_index "counselings", ["military_branch_id"], name: "military_branch_id", using: :btree
  add_index "counselings", ["military_employer_id"], name: "military_employer_id", using: :btree
  add_index "counselings", ["military_service_id"], name: "military_service_id", using: :btree
  add_index "counselings", ["pension_earner_id"], name: "pension_earner_id", using: :btree
  add_index "counselings", ["selected_plan_id"], name: "selected_plan_id", using: :btree

  create_table "counties", force: true do |t|
    t.string "name"
    t.string "fips_code"
    t.string "state_abbrev"
  end

  add_index "counties", ["fips_code", "state_abbrev"], name: "index_counties_on_fips_code_and_state_abbrev", unique: true, using: :btree

  create_table "dup_temp", id: false, force: true do |t|
    t.integer "AgencyID",        default: 0, null: false
    t.string  "Agency Name"
    t.string  "Agency Name 2"
    t.integer "LocationID",      default: 0, null: false
    t.string  "Location Name"
    t.string  "Location Name 2"
  end

  create_table "employee_types", force: true do |t|
    t.string "name"
  end

  create_table "employer_types", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "expertises", force: true do |t|
    t.string "name"
    t.string "form"
  end

  create_table "expertises_partners", id: false, force: true do |t|
    t.integer "expertise_id"
    t.integer "partner_id"
  end

  add_index "expertises_partners", ["expertise_id"], name: "expertise_id", using: :btree
  add_index "expertises_partners", ["partner_id"], name: "partner_id", using: :btree

  create_table "federal_plans", force: true do |t|
    t.string  "name"
    t.integer "position"
    t.integer "parent_id"
    t.integer "associated_plan_id"
  end

  add_index "federal_plans", ["associated_plan_id"], name: "associated_plan_id", using: :btree
  add_index "federal_plans", ["parent_id"], name: "parent_id", using: :btree

  create_table "fee_arrangements", force: true do |t|
    t.string "name"
  end

  create_table "fee_arrangements_partners", id: false, force: true do |t|
    t.integer "partner_id"
    t.integer "fee_arrangement_id"
  end

  add_index "fee_arrangements_partners", ["fee_arrangement_id"], name: "fee_arrangement_id", using: :btree
  add_index "fee_arrangements_partners", ["partner_id"], name: "partner_id", using: :btree

  create_table "feedbacks", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "availability"
    t.string   "category"
    t.text     "feedback"
    t.boolean  "is_resolved",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state_abbrev", limit: 2
  end

  create_table "fmp1_agencies", primary_key: "Serial", force: true do |t|
    t.string   "agency_name_1"
    t.string   "agency_name_2"
    t.text     "comments"
    t.string   "con_ad_drop_city"
    t.string   "con_ad_drop_state"
    t.string   "con_ad_drop_street_1"
    t.string   "con_ad_drop_street_2"
    t.string   "con_ad_drop_zip"
    t.string   "con_ad_mail_city"
    t.string   "con_ad_mail_state"
    t.string   "con_ad_mail_street_1"
    t.string   "con_ad_mail_street_2"
    t.string   "con_ad_mail_zip"
    t.string   "con_email"
    t.string   "con_ext_local"
    t.string   "con_ext_toll_free"
    t.string   "con_ext_tty"
    t.string   "con_phone_fax"
    t.string   "con_phone_local"
    t.string   "con_phone_toll_free"
    t.string   "con_phone_tty"
    t.string   "con_pubs_email"
    t.string   "con_pubs_ext_local"
    t.string   "con_pubs_ext_toll_free"
    t.string   "con_pubs_ext_tty"
    t.string   "con_pubs_fax"
    t.string   "con_pubs_local"
    t.string   "con_pubs_toll_free"
    t.string   "con_pubs_tty"
    t.string   "con_pubs_url"
    t.string   "con_url_1"
    t.string   "con_url_2"
    t.string   "con_url_title_1"
    t.string   "con_url_title_2"
    t.text     "descriptive_summary"
    t.string   "hours_o_operation"
    t.text     "logisitics"
    t.string   "pension_system"
    t.decimal  "res_max_poverty_percent",    precision: 9, scale: 2
    t.decimal  "res_min_age",                precision: 5, scale: 2
    t.text     "services_provided"
    t.string   "source_o_data"
    t.datetime "stamp_creation"
    t.datetime "stamp_modification"
    t.string   "sts_status_flag"
    t.string   "user_modification"
    t.string   "help_book_macro"
    t.string   "help_book_micro"
    t.string   "service_provider"
    t.string   "other_services_provided"
    t.string   "sts_status"
    t.string   "non_pension_resource_types"
    t.string   "military_branches"
    t.string   "public_plan_type"
    t.boolean  "import_to_pha",                                      default: true, null: false
  end

  create_table "fmp1_subagencies", primary_key: "Serial", force: true do |t|
    t.integer  "AgencyId"
    t.string   "agency_name_1"
    t.string   "agency_name_2"
    t.text     "comments"
    t.string   "con_ad_drop_city"
    t.string   "con_ad_drop_state"
    t.string   "con_ad_drop_street_1"
    t.string   "con_ad_drop_street_2"
    t.string   "con_ad_drop_zip"
    t.string   "con_ad_mail_city"
    t.string   "con_ad_mail_state"
    t.string   "con_ad_mail_street_1"
    t.string   "con_ad_mail_street_2"
    t.string   "con_ad_mail_zip"
    t.string   "con_email"
    t.string   "con_ext_local"
    t.string   "con_ext_toll_free"
    t.string   "con_ext_tty"
    t.string   "con_phone_fax"
    t.string   "con_phone_local"
    t.string   "con_phone_toll_free"
    t.string   "con_phone_tty"
    t.string   "con_pubs_email"
    t.string   "con_pubs_ext_local"
    t.string   "con_pubs_ext_toll_free"
    t.string   "con_pubs_ext_tty"
    t.string   "con_pubs_fax"
    t.string   "con_pubs_local"
    t.string   "con_pubs_toll_free"
    t.string   "con_pubs_tty"
    t.string   "con_pubs_url"
    t.string   "con_url_1"
    t.string   "con_url_2"
    t.string   "con_url_title_1"
    t.string   "con_url_title_2"
    t.text     "descriptive_summary"
    t.string   "hours_o_operation"
    t.text     "logisitics"
    t.text     "services_provided"
    t.string   "source_o_data"
    t.datetime "stamp_creation"
    t.datetime "stamp_modification"
    t.string   "sts_status_flag"
    t.string   "user_modification"
    t.string   "other_services_provided"
    t.string   "sts_status"
    t.string   "non_pension_resource_types"
  end

  create_table "fmp2", primary_key: "newDbSerial", force: true do |t|
    t.string  "ResultType"
    t.integer "OldPHA_AgencySerialNumber"
    t.integer "OldPHA_BabiesSerialNumber"
    t.string  "AgencyName1"
    t.string  "AgencyName2"
    t.text    "PlanDescription"
    t.text    "Comments"
    t.string  "AgencyMailStreet1"
    t.string  "AgencyMailStreet2"
    t.string  "AgencyMailCity"
    t.string  "AgencyMailState"
    t.string  "AgencyMailZip"
    t.string  "AgencyDropInStreet1"
    t.string  "AgencyDropInStreet2"
    t.string  "AgencyDropInCity"
    t.string  "AgencyDropInState"
    t.string  "AgencyDropInZip"
    t.string  "AgencyTollFreePhone"
    t.string  "AgencyLocalPhone"
    t.string  "AgencyFax"
    t.string  "AgencyTTYPhone"
    t.string  "AgencyTollFreePhoneExt"
    t.string  "AgencyLocalPhoneExt"
    t.string  "AgencyTTYPhoneExt"
    t.string  "AgencyEmail"
    t.string  "AgencyURL"
    t.string  "PlanURL"
    t.string  "AgencyURLTitle"
    t.string  "PlanURLTitle"
    t.string  "AgencyPubsTollFreePhone"
    t.string  "AgencyPubsLocalPhone"
    t.string  "AgencyPubsTTYPhone"
    t.string  "AgencyPubsTollFreePhoneExt"
    t.string  "AgencyPubsLocalPhoneExt"
    t.string  "AgencyPubsTTYPhoneExt"
    t.string  "AgencyPubsURL"
    t.string  "RecordStatus"
    t.string  "AgencyPubsURLTitle"
    t.string  "SPDURL"
    t.string  "SPDURLTitle"
    t.date    "PlanStartDate"
    t.date    "PlanEndDate"
    t.text    "CoveredEmployee"
    t.string  "PlanType1"
    t.string  "PlanType2"
    t.string  "PlanType3"
    t.string  "PlanName1"
    t.string  "PlanName2"
    t.string  "TPAURL"
    t.string  "TPAURL_Title"
    t.text    "CatchallEmployees"
    t.string  "ServiceGeographyType"
    t.string  "GeographicServiceInformation"
    t.string  "GovtCounty"
    t.string  "GovtSpDist"
    t.string  "GovtState"
    t.string  "GovtEmployerType"
    t.string  "MultipleOffices"
    t.integer "primary_serial"
    t.integer "loc_serial"
    t.integer "plan_serial"
  end

  create_table "geo_areas", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "help_additional_areas", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "images", force: true do |t|
    t.integer "parent_id"
    t.string  "thumbnail"
    t.string  "filename"
    t.string  "content_type"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.float   "aspect_ratio", limit: 24
  end

  add_index "images", ["parent_id"], name: "parent_id", using: :btree

  create_table "jurisdictions", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "location_plan_relationships", force: true do |t|
    t.integer "location_id"
    t.integer "plan_id"
    t.boolean "is_hq"
  end

  add_index "location_plan_relationships", ["location_id"], name: "location_id", using: :btree
  add_index "location_plan_relationships", ["plan_id"], name: "plan_id", using: :btree

  create_table "locations", force: true do |t|
    t.integer  "agency_id"
    t.string   "name"
    t.string   "name2"
    t.boolean  "is_hq"
    t.boolean  "is_provider"
    t.string   "tollfree",           limit: 20
    t.string   "tollfree_ext",       limit: 10
    t.string   "phone",              limit: 20
    t.string   "phone_ext",          limit: 10
    t.string   "tty",                limit: 20
    t.string   "tty_ext",            limit: 10
    t.string   "fax",                limit: 20
    t.string   "email"
    t.string   "hours_of_operation"
    t.string   "logistics"
    t.datetime "updated_at"
    t.string   "legacy_code",        limit: 10
    t.string   "legacy_subcode",     limit: 10
    t.string   "fmp2_code",          limit: 10
    t.string   "updated_by"
    t.string   "url"
    t.string   "url_title"
    t.string   "url2"
    t.string   "url2_title"
    t.integer  "position"
    t.string   "pha_contact_name"
    t.string   "pha_contact_title"
    t.string   "pha_contact_phone",  limit: 20
    t.string   "pha_contact_email"
    t.text     "comment"
    t.boolean  "is_active",                     default: true
  end

  add_index "locations", ["agency_id"], name: "agency_id", using: :btree

  create_table "military_branches", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "military_employers", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "military_services", force: true do |t|
    t.string  "name"
    t.integer "position"
    t.boolean "is_active", default: true
  end

  create_table "news", force: true do |t|
    t.string   "title"
    t.text     "intro"
    t.string   "article_url"
    t.string   "source_url"
    t.boolean  "is_internal"
    t.text     "body"
    t.date     "publish_date"
    t.date     "archive_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "updated_by"
    t.integer  "position"
  end

  create_table "npln_additional_areas", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "npln_participation_levels", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "page_emails", force: true do |t|
    t.string   "page_title"
    t.string   "link"
    t.string   "name"
    t.string   "email"
    t.string   "recipient_name"
    t.string   "recipient_email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pal_additional_areas", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "pal_participation_levels", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "participations", force: true do |t|
    t.string "name"
  end

  create_table "participations_partners", id: false, force: true do |t|
    t.integer "partner_id"
    t.integer "participations_id"
  end

  add_index "participations_partners", ["participations_id"], name: "participations_id", using: :btree
  add_index "participations_partners", ["partner_id"], name: "partner_id", using: :btree

  create_table "partners", force: true do |t|
    t.string  "first_name",                                   limit: 80
    t.string  "last_name",                                    limit: 80
    t.string  "company"
    t.string  "line_1"
    t.string  "line_2"
    t.string  "city",                                         limit: 50
    t.string  "state_abbrev",                                 limit: 2
    t.string  "zip_code",                                     limit: 10
    t.string  "phone",                                        limit: 20
    t.string  "fax",                                          limit: 20
    t.string  "email"
    t.string  "url"
    t.text    "other_info"
    t.boolean "wants_npln",                                              default: false
    t.boolean "wants_pal",                                               default: false
    t.integer "preferred_method_of_contact"
    t.string  "fee_for_initial_consultation"
    t.string  "hourly_continuous_fee"
    t.string  "professional_certifications_and_affiliations"
    t.boolean "has_other_areas_of_expertise",                            default: false
    t.string  "other_areas_of_expertise"
    t.boolean "dr_lawyer",                                               default: false
    t.boolean "has_other_level_of_participation",                        default: false
    t.string  "other_level_of_participation"
    t.string  "law_practice_states"
    t.string  "law_practice_circuits"
    t.boolean "us_supreme_court",                                        default: false
    t.boolean "malpractice_insurance",                                   default: false
    t.string  "tollfree_number"
    t.string  "local_number"
    t.text    "office_location"
    t.boolean "wants_lsp",                                               default: false
  end

  create_table "partners_claim_types", id: false, force: true do |t|
    t.integer "partner_id",    null: false
    t.integer "claim_type_id", null: false
  end

  add_index "partners_claim_types", ["claim_type_id", "partner_id"], name: "index_partners_claim_types_on_claim_type_id_and_partner_id", using: :btree

  create_table "partners_geo_areas", force: true do |t|
    t.integer "partner_id"
    t.integer "geo_area_id"
  end

  add_index "partners_geo_areas", ["geo_area_id"], name: "geo_area_id", using: :btree
  add_index "partners_geo_areas", ["partner_id"], name: "partner_id", using: :btree

  create_table "partners_help_additional_areas", id: false, force: true do |t|
    t.integer "partner_id",              null: false
    t.integer "help_additional_area_id", null: false
  end

  add_index "partners_help_additional_areas", ["help_additional_area_id", "partner_id"], name: "partners_help_areas", using: :btree

  create_table "partners_jurisdictions", force: true do |t|
    t.integer "partner_id"
    t.integer "jurisdiction_id"
  end

  add_index "partners_jurisdictions", ["jurisdiction_id"], name: "jurisdiction_id", using: :btree
  add_index "partners_jurisdictions", ["partner_id"], name: "partner_id", using: :btree

  create_table "partners_npln_additional_areas", id: false, force: true do |t|
    t.integer "partner_id",              null: false
    t.integer "npln_additional_area_id", null: false
  end

  add_index "partners_npln_additional_areas", ["npln_additional_area_id", "partner_id"], name: "partners_npln_areas", using: :btree

  create_table "partners_npln_participation_levels", id: false, force: true do |t|
    t.integer "partner_id",                  null: false
    t.integer "npln_participation_level_id", null: false
  end

  add_index "partners_npln_participation_levels", ["npln_participation_level_id", "partner_id"], name: "partners_npln_participations", using: :btree

  create_table "partners_pal_additional_areas", id: false, force: true do |t|
    t.integer "partner_id",             null: false
    t.integer "pal_additional_area_id", null: false
  end

  add_index "partners_pal_additional_areas", ["pal_additional_area_id", "partner_id"], name: "partners_pal_areas", using: :btree

  create_table "partners_pal_participation_levels", id: false, force: true do |t|
    t.integer "partner_id",                 null: false
    t.integer "pal_participation_level_id", null: false
  end

  add_index "partners_pal_participation_levels", ["pal_participation_level_id", "partner_id"], name: "partners_pal_participations", using: :btree

  create_table "partners_plan_types", id: false, force: true do |t|
    t.integer "partner_id",   null: false
    t.integer "plan_type_id", null: false
  end

  add_index "partners_plan_types", ["plan_type_id", "partner_id"], name: "index_partners_plan_types_on_plan_type_id_and_partner_id", using: :btree

  create_table "partners_practices", id: false, force: true do |t|
    t.integer "partner_id"
    t.integer "practice_id"
  end

  add_index "partners_practices", ["partner_id"], name: "partner_id", using: :btree
  add_index "partners_practices", ["practice_id"], name: "practice_id", using: :btree

  create_table "partners_professions", id: false, force: true do |t|
    t.integer "partner_id",    null: false
    t.integer "profession_id", null: false
  end

  add_index "partners_professions", ["profession_id", "partner_id"], name: "index_partners_professions_on_profession_id_and_partner_id", using: :btree

  create_table "partners_referral_fees", id: false, force: true do |t|
    t.integer "partner_id",      null: false
    t.integer "referral_fee_id", null: false
  end

  add_index "partners_referral_fees", ["referral_fee_id", "partner_id"], name: "index_partners_referral_fees_on_referral_fee_id_and_partner_id", using: :btree

  create_table "partners_search_plan_types", id: false, force: true do |t|
    t.integer "partner_id",          null: false
    t.integer "search_plan_type_id", null: false
  end

  add_index "partners_search_plan_types", ["search_plan_type_id", "partner_id"], name: "partners_search_plans", using: :btree

  create_table "partners_sponsor_types", id: false, force: true do |t|
    t.integer "partner_id",      null: false
    t.integer "sponsor_type_id", null: false
  end

  add_index "partners_sponsor_types", ["sponsor_type_id", "partner_id"], name: "index_partners_sponsor_types_on_sponsor_type_id_and_partner_id", using: :btree

  create_table "pension_earners", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "plan_catch_all_employees", force: true do |t|
    t.integer "plan_id"
    t.integer "employee_type_id"
    t.integer "position"
  end

  add_index "plan_catch_all_employees", ["employee_type_id"], name: "employee_type_id", using: :btree
  add_index "plan_catch_all_employees", ["plan_id"], name: "plan_id", using: :btree

  create_table "plan_categories", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "plan_types", force: true do |t|
    t.string  "name"
    t.integer "position"
    t.boolean "use_for_pal"
  end

  create_table "plans", force: true do |t|
    t.integer  "agency_id"
    t.string   "name"
    t.string   "name2"
    t.text     "description"
    t.text     "comments"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "covered_employees"
    t.string   "plan_type1"
    t.string   "plan_type2"
    t.string   "plan_type3"
    t.string   "url"
    t.string   "url_title"
    t.string   "admin_url"
    t.string   "admin_url_title"
    t.string   "tpa_url"
    t.string   "tpa_url_title"
    t.string   "spd_url"
    t.string   "spd_url_title"
    t.string   "govt_employee_type"
    t.string   "fmp2_code"
    t.string   "legacy_category"
    t.string   "legacy_status"
    t.datetime "updated_at"
    t.string   "updated_by"
    t.string   "email"
    t.integer  "position"
    t.string   "pha_contact_name"
    t.string   "pha_contact_title"
    t.string   "pha_contact_phone",     limit: 20
    t.string   "pha_contact_email"
    t.boolean  "is_active",                        default: true
    t.string   "previous_gov_employee"
    t.integer  "plan_category_id"
  end

  add_index "plans", ["agency_id"], name: "agency_id", using: :btree
  add_index "plans", ["plan_category_id"], name: "plan_category_id", using: :btree

  create_table "poverty_levels", force: true do |t|
    t.integer "year"
    t.integer "number_in_household"
    t.string  "geographic"
    t.decimal "fpl",                 precision: 8, scale: 2
  end

  create_table "practices", force: true do |t|
    t.string "name"
  end

  create_table "professions", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "publications", force: true do |t|
    t.integer "agency_id"
    t.string  "tollfree",     limit: 20
    t.string  "tollfree_ext", limit: 10
    t.string  "phone",        limit: 20
    t.string  "phone_ext",    limit: 10
    t.string  "tty",          limit: 20
    t.string  "tty_ext",      limit: 10
    t.string  "fax",          limit: 20
    t.string  "email"
    t.string  "url"
    t.string  "url_title"
    t.string  "legacy_code",  limit: 10
    t.string  "fmp2_code",    limit: 10
  end

  add_index "publications", ["agency_id"], name: "agency_id", using: :btree

  create_table "referral_fees", force: true do |t|
    t.string  "name"
    t.integer "position"
    t.boolean "use_for_pal", default: true
  end

  create_table "restrictions", force: true do |t|
    t.integer  "agency_id"
    t.integer  "location_id"
    t.integer  "plan_id"
    t.integer  "minimum_age"
    t.integer  "max_poverty"
    t.string   "special_district"
    t.text     "other_restrictions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "legacy_geo_states"
    t.string   "legacy_code",          limit: 10
    t.string   "legacy_subcode",       limit: 10
    t.string   "fmp2_code",            limit: 10
    t.text     "legacy_geo_counties"
    t.text     "legacy_geo_cities"
    t.boolean  "age_and_income"
    t.string   "age_restricted_phone", limit: 20
  end

  add_index "restrictions", ["agency_id"], name: "agency_id", using: :btree
  add_index "restrictions", ["location_id"], name: "location_id", using: :btree
  add_index "restrictions", ["plan_id"], name: "plan_id", using: :btree

  create_table "restrictions_cities", id: false, force: true do |t|
    t.integer "restriction_id", null: false
    t.integer "city_id",        null: false
  end

  add_index "restrictions_cities", ["city_id", "restriction_id"], name: "index_restrictions_cities_on_city_id_and_restriction_id", using: :btree

  create_table "restrictions_counties", id: false, force: true do |t|
    t.integer "restriction_id", null: false
    t.integer "county_id",      null: false
  end

  add_index "restrictions_counties", ["county_id", "restriction_id"], name: "index_restrictions_counties_on_county_id_and_restriction_id", using: :btree

  create_table "restrictions_reload", primary_key: "sn", force: true do |t|
    t.integer  "discriminatory_count"
    t.text     "sp_display_babies_states"
    t.text     "sp_display_babies_counties"
    t.text     "sp_display_babies_cities"
    t.text     "sp_display_counseling_states"
    t.text     "sp_display_counseling_counties"
    t.text     "sp_display_counseling_cities"
    t.string   "res_geographic"
    t.string   "res_geographic_meaning"
    t.string   "res_languages"
    t.integer  "res_max_age"
    t.decimal  "res_max_poverty_percent",         precision: 8, scale: 2
    t.string   "res_military"
    t.integer  "res_min_age"
    t.integer  "res_pop_number_o_family_members"
    t.integer  "res_pov_guide_year"
    t.integer  "res_pov_threshold_household"
    t.string   "res_pov_threshold_type"
    t.string   "res_residency"
    t.string   "res_resident"
    t.string   "res_restriction_categories"
    t.integer  "sn_o_baby"
    t.integer  "sn_o_counseling"
    t.datetime "stamp_creation"
    t.datetime "stamp_modification"
    t.string   "user_creation"
    t.string   "user_modification"
  end

  create_table "restrictions_states", id: false, force: true do |t|
    t.integer "restriction_id",           null: false
    t.string  "state_abbrev",   limit: 2, null: false
  end

  add_index "restrictions_states", ["state_abbrev", "restriction_id"], name: "index_restrictions_states_on_state_abbrev_and_restriction_id", using: :btree

  create_table "restrictions_zips", id: false, force: true do |t|
    t.integer "restriction_id",           null: false
    t.string  "zipcode",        limit: 5, null: false
  end

  add_index "restrictions_zips", ["zipcode", "restriction_id"], name: "index_restrictions_zips_on_zipcode_and_restriction_id", using: :btree

  create_table "result_types", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "roles", force: true do |t|
    t.string "role_name"
    t.string "description"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["role_id"], name: "role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "user_id", using: :btree

  create_table "schema_info", id: false, force: true do |t|
    t.integer "version"
  end

  create_table "search_plan_types", force: true do |t|
    t.string  "name"
    t.integer "position"
  end

  create_table "sponsor_types", force: true do |t|
    t.string  "name"
    t.integer "position"
    t.boolean "use_for_pal",    default: true
    t.boolean "use_for_search", default: false
    t.boolean "use_for_npln",   default: true
    t.boolean "use_for_help",   default: true
  end

  create_table "states", primary_key: "abbrev", force: true do |t|
    t.string "name", limit: 50
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          limit: 40
    t.string   "salt",                      limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "is_random_pass"
    t.string   "encrypted_password",                   default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "zip_import", id: false, force: true do |t|
    t.string  "zipcode",      limit: 5,                          null: false
    t.string  "city",         limit: 64
    t.string  "county",       limit: 64
    t.string  "state_abbrev", limit: 2
    t.string  "zip_type",     limit: 1
    t.string  "city_type",    limit: 1
    t.string  "county_fips",  limit: 5
    t.string  "state_name",   limit: 64
    t.string  "state_fips",   limit: 2
    t.string  "msa_code",     limit: 4
    t.string  "area_code",    limit: 16
    t.string  "time_zone",    limit: 16
    t.decimal "utc",                     precision: 3, scale: 1
    t.string  "dst",          limit: 1
    t.decimal "latitude",                precision: 9, scale: 6
    t.decimal "longitude",               precision: 9, scale: 6
  end

  add_index "zip_import", ["city"], name: "index_zip_import_on_city", using: :btree
  add_index "zip_import", ["county"], name: "index_zip_import_on_county", using: :btree
  add_index "zip_import", ["state_abbrev"], name: "index_zip_import_on_state_abbrev", using: :btree
  add_index "zip_import", ["zipcode"], name: "index_zip_import_on_zipcode", using: :btree

  create_table "zips", primary_key: "zipcode", force: true do |t|
    t.string  "state_abbrev"
    t.integer "county_id"
  end

  add_index "zips", ["county_id"], name: "county_id", using: :btree

end
