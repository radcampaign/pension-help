# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 20) do

  create_table "addresses", :force => true do |t|
    t.column "line1",          :string
    t.column "line2",          :string
    t.column "city",           :string,  :limit => 64
    t.column "state_abbrev",   :string
    t.column "zip",            :string
    t.column "address_type",   :string
    t.column "location_id",    :integer
    t.column "legacy_code",    :string
    t.column "legacy_subcode", :string
  end

  add_index "addresses", ["location_id"], :name => "location_id"

  create_table "agencies", :force => true do |t|
    t.column "name",             :string
    t.column "name2",            :string
    t.column "data_source",      :string
    t.column "is_active",        :boolean
    t.column "url",              :string
    t.column "url_title",        :string
    t.column "legacy_code",      :string
    t.column "legacy_subcode",   :string
    t.column "created_at",       :datetime
    t.column "updated_at",       :datetime
    t.column "updated_by",       :string
    t.column "plan_category_id", :integer
  end

  add_index "agencies", ["plan_category_id"], :name => "plan_category_id"

  create_table "cities", :force => true do |t|
    t.column "name",         :string
    t.column "county_id",    :integer
    t.column "state_abbrev", :string
  end

  add_index "cities", ["county_id"], :name => "county_id"

  create_table "contacts", :force => true do |t|
    t.column "first_name",       :string,  :limit => 80
    t.column "last_name",        :string,  :limit => 80
    t.column "middle_initial",   :string,  :limit => 2
    t.column "company",          :string
    t.column "line_1",           :string
    t.column "line_2",           :string
    t.column "city",             :string,  :limit => 50
    t.column "state_abbrev",     :string,  :limit => 2
    t.column "zip_code",         :string,  :limit => 10
    t.column "phone",            :string,  :limit => 20
    t.column "fax",              :string,  :limit => 20
    t.column "email",            :string
    t.column "url",              :string
    t.column "profession_id",    :integer
    t.column "profession_other", :string
    t.column "affiliations",     :string
    t.column "wants_npln",       :boolean
    t.column "wants_aaa",        :boolean
  end

  create_table "contents", :force => true do |t|
    t.column "url",        :string
    t.column "title",      :string
    t.column "content",    :text
    t.column "created_at", :string
    t.column "updated_at", :datetime
    t.column "updated_by", :string
  end

  create_table "counties", :force => true do |t|
    t.column "name",         :string
    t.column "fips_code",    :string
    t.column "state_abbrev", :string
  end

  create_table "fmp2", :force => true do |t|
    t.column "ResultType",                   :string
    t.column "OldPHA_AgencySerialNumber",    :string
    t.column "OldPHA_BabiesSerialNumber",    :string
    t.column "AgencyName1",                  :string
    t.column "AgencyName2",                  :string
    t.column "PlanDescription",              :text
    t.column "Comments",                     :text
    t.column "AgencyMailStreet1",            :string
    t.column "AgencyMailStreet2",            :string
    t.column "AgencyMailCity",               :string
    t.column "AgencyMailState",              :string
    t.column "AgencyMailZip",                :string
    t.column "AgencyDropInStreet1",          :string
    t.column "AgencyDropInStreet2",          :string
    t.column "AgencyDropInCity",             :string
    t.column "AgencyDropInState",            :string
    t.column "AgencyDropInZip",              :string
    t.column "AgencyTollFreePhone",          :string
    t.column "AgencyLocalPhone",             :string
    t.column "AgencyFax",                    :string
    t.column "AgencyTTYPhone",               :string
    t.column "AgencyTollFreePhoneExt",       :string
    t.column "AgencyLocalPhoneExt",          :string
    t.column "AgencyTTYPhoneExt",            :string
    t.column "AgencyEmail",                  :string
    t.column "AgencyURL",                    :string
    t.column "PlanURL",                      :string
    t.column "AgencyURLTitle",               :string
    t.column "PlanURLTitle",                 :string
    t.column "AgencyPubsTollFreePhone",      :string
    t.column "AgencyPubsLocalPhone",         :string
    t.column "AgencyPubsTTYPhone",           :string
    t.column "AgencyPubsTollFreePhoneExt",   :string
    t.column "AgencyPubsLocalPhoneExt",      :string
    t.column "AgencyPubsTTYPhoneExt",        :string
    t.column "AgencyPubsURL",                :string
    t.column "RecordStatus",                 :string
    t.column "AgencyPubsURLTitle",           :string
    t.column "SPDURL",                       :string
    t.column "SPDURLTitle",                  :string
    t.column "PlanStartDate",                :date
    t.column "PlanEndDate",                  :date
    t.column "CoveredEmployee",              :text
    t.column "PlanType1",                    :string
    t.column "PlanType2",                    :string
    t.column "PlanType3",                    :string
    t.column "PlanName1",                    :string
    t.column "PlanName2",                    :string
    t.column "TPAURL",                       :string
    t.column "TPAURL_Title",                 :string
    t.column "CatchallEmployees",            :text
    t.column "ServiceGeographyType",         :string
    t.column "GeographicServiceInformation", :string
    t.column "GovtCounty",                   :string
    t.column "GovtSpDist",                   :string
    t.column "GovtState",                    :string
    t.column "GovtEmployerType",             :string
  end

  create_table "help_nets", :force => true do |t|
    t.column "contact_id",       :integer
    t.column "exp_erisa_single", :boolean
    t.column "exp_erisa_multi",  :boolean
    t.column "exp_fed",          :boolean
    t.column "exp_state",        :boolean
    t.column "exp_church",       :boolean
    t.column "exp_other",        :string
    t.column "other_info",       :string
    t.column "wont_charge_fees", :boolean
  end

  create_table "images", :force => true do |t|
    t.column "parent_id",    :integer
    t.column "thumbnail",    :string
    t.column "filename",     :string
    t.column "content_type", :string
    t.column "size",         :integer
    t.column "width",        :integer
    t.column "height",       :integer
    t.column "aspect_ratio", :float
  end

  add_index "images", ["parent_id"], :name => "parent_id"

  create_table "locations", :force => true do |t|
    t.column "name",               :string
    t.column "is_hq",              :boolean
    t.column "agency_id",          :integer
    t.column "phone",              :string,   :limit => 20
    t.column "phone_ext",          :string,   :limit => 10
    t.column "tollfree",           :string,   :limit => 20
    t.column "tollfree_ext",       :string,   :limit => 10
    t.column "fax",                :string,   :limit => 20
    t.column "tty",                :string,   :limit => 20
    t.column "tty_ext",            :string,   :limit => 10
    t.column "email",              :string
    t.column "hours_of_operation", :string
    t.column "logistics",          :string
    t.column "legacy_subcode",     :string,   :limit => 10
    t.column "created_at",         :datetime
    t.column "updated_at",         :datetime
    t.column "updated_by",         :string
    t.column "legacy_code",        :string
  end

  add_index "locations", ["agency_id"], :name => "agency_id"

  create_table "locations_counties", :id => false, :force => true do |t|
    t.column "location_id", :integer, :null => false
    t.column "county_id",   :integer, :null => false
  end

  add_index "locations_counties", ["county_id", "location_id"], :name => "index_locations_counties_on_county_id_and_location_id"

  create_table "locations_states", :id => false, :force => true do |t|
    t.column "location_id",  :integer,              :null => false
    t.column "state_abbrev", :string,  :limit => 2, :null => false
  end

  add_index "locations_states", ["state_abbrev", "location_id"], :name => "index_locations_states_on_state_abbrev_and_location_id"

  create_table "news", :force => true do |t|
    t.column "title",        :string
    t.column "intro",        :text
    t.column "article_url",  :string
    t.column "source_url",   :string
    t.column "is_internal",  :boolean
    t.column "body",         :text
    t.column "publish_date", :date
    t.column "archive_date", :date
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
    t.column "updated_by",   :string
  end

  create_table "plan_categories", :force => true do |t|
    t.column "name",     :string
    t.column "position", :integer
  end

  create_table "plans", :force => true do |t|
    t.column "name",                :string
    t.column "name2",               :string
    t.column "agency_id",           :integer
    t.column "start_date",          :date
    t.column "end_date",            :date
    t.column "covered_employees",   :text
    t.column "catchall_employees",  :text
    t.column "description",         :text
    t.column "service_description", :text
    t.column "comments",            :text
    t.column "status",              :string
    t.column "govt_employee_type",  :string
    t.column "special_district",    :string
    t.column "plan_type1",          :string
    t.column "plan_type2",          :string
    t.column "plan_type3",          :string
    t.column "url",                 :string
    t.column "url_title",           :string
    t.column "admin_url",           :string
    t.column "admin_url_title",     :string
    t.column "tpa_url",             :string
    t.column "tpa_url_title",       :string
    t.column "spd_url",             :string
    t.column "spd_url_title",       :string
    t.column "created_at",          :datetime
    t.column "updated_at",          :datetime
    t.column "updated_by",          :string
    t.column "age_threshold",       :decimal,  :precision => 5, :scale => 2
    t.column "income_threshold",    :decimal,  :precision => 9, :scale => 2
    t.column "legacy_category",     :string
    t.column "legacy_code",         :string
    t.column "legacy_geo_type",     :string
    t.column "legacy_geo_info",     :string
    t.column "legacy_geo_states",   :string
    t.column "legacy_geo_counties", :string
  end

  add_index "plans", ["agency_id"], :name => "agency_id"

  create_table "plans_cities", :id => false, :force => true do |t|
    t.column "plan_id", :integer, :null => false
    t.column "city_id", :integer, :null => false
  end

  add_index "plans_cities", ["city_id", "plan_id"], :name => "index_plans_cities_on_city_id_and_plan_id"

  create_table "plans_counties", :id => false, :force => true do |t|
    t.column "plan_id",   :integer, :null => false
    t.column "county_id", :integer, :null => false
  end

  add_index "plans_counties", ["county_id", "plan_id"], :name => "index_plans_counties_on_county_id_and_plan_id"

  create_table "plans_states", :id => false, :force => true do |t|
    t.column "plan_id",      :integer,              :null => false
    t.column "state_abbrev", :string,  :limit => 2, :null => false
  end

  add_index "plans_states", ["state_abbrev", "plan_id"], :name => "index_plans_states_on_state_abbrev_and_plan_id"

  create_table "plans_zips", :id => false, :force => true do |t|
    t.column "plan_id", :integer,              :null => false
    t.column "zipcode", :string,  :limit => 5, :null => false
  end

  add_index "plans_zips", ["zipcode", "plan_id"], :name => "index_plans_zips_on_zipcode_and_plan_id"

  create_table "professions", :force => true do |t|
    t.column "name",     :string
    t.column "position", :integer
  end

  create_table "publications", :force => true do |t|
    t.column "name",         :string
    t.column "plan_id",      :integer
    t.column "phone",        :string,   :limit => 20
    t.column "phone_ext",    :string,   :limit => 10
    t.column "tollfree",     :string,   :limit => 20
    t.column "tollfree_ext", :string,   :limit => 10
    t.column "fax",          :string,   :limit => 20
    t.column "tty",          :string,   :limit => 20
    t.column "tty_ext",      :string,   :limit => 10
    t.column "email",        :string
    t.column "url",          :string
    t.column "url_title",    :string
    t.column "created_at",   :datetime
    t.column "updated_at",   :datetime
    t.column "legacy_code",  :string
  end

  add_index "publications", ["plan_id"], :name => "plan_id"

  create_table "search_nets", :force => true do |t|
    t.column "contact_id",       :integer
    t.column "wont_charge_fees", :boolean
    t.column "info_plans",       :string
    t.column "info_geo",         :string
    t.column "info_industries",  :string
    t.column "info_referrals",   :string
  end

  create_table "states", :id => false, :force => true do |t|
    t.column "abbrev", :string, :limit => 2,  :null => false
    t.column "name",   :string, :limit => 50
  end

  create_table "users", :force => true do |t|
    t.column "login",                     :string
    t.column "email",                     :string
    t.column "crypted_password",          :string,   :limit => 40
    t.column "salt",                      :string,   :limit => 40
    t.column "created_at",                :datetime
    t.column "updated_at",                :datetime
    t.column "remember_token",            :string
    t.column "remember_token_expires_at", :datetime
  end

  create_table "zip_import", :id => false, :force => true do |t|
    t.column "zipcode",      :string,  :limit => 5,                                :null => false
    t.column "city",         :string,  :limit => 64
    t.column "county",       :string,  :limit => 64
    t.column "state_abbrev", :string,  :limit => 2
    t.column "zip_type",     :string,  :limit => 1
    t.column "city_type",    :string,  :limit => 1
    t.column "county_fips",  :string,  :limit => 5
    t.column "state_name",   :string,  :limit => 64
    t.column "state_fips",   :string,  :limit => 2
    t.column "msa_code",     :string,  :limit => 4
    t.column "area_code",    :string,  :limit => 16
    t.column "time_zone",    :string,  :limit => 16
    t.column "utc",          :decimal,               :precision => 3, :scale => 1
    t.column "dst",          :boolean
    t.column "latitude",     :decimal,               :precision => 9, :scale => 6
    t.column "longitude",    :decimal,               :precision => 9, :scale => 6
  end

  add_index "zip_import", ["zipcode"], :name => "index_zip_import_on_zipcode"
  add_index "zip_import", ["city"], :name => "index_zip_import_on_city"
  add_index "zip_import", ["county"], :name => "index_zip_import_on_county"
  add_index "zip_import", ["state_abbrev"], :name => "index_zip_import_on_state_abbrev"

  create_table "zips", :id => false, :force => true do |t|
    t.column "zipcode",      :string
    t.column "state_abbrev", :string
  end

  add_foreign_key "addresses", ["location_id"], "locations", ["id"], :name => "addresses_ibfk_1"

  add_foreign_key "agencies", ["plan_category_id"], "plan_categories", ["id"], :name => "agencies_ibfk_1"

  add_foreign_key "cities", ["county_id"], "counties", ["id"], :name => "cities_ibfk_1"

  add_foreign_key "images", ["parent_id"], "images", ["id"], :name => "images_ibfk_1"

  add_foreign_key "locations", ["agency_id"], "agencies", ["id"], :name => "locations_ibfk_1"

  add_foreign_key "locations_counties", ["location_id"], "locations", ["id"], :name => "locations_counties_ibfk_1"
  add_foreign_key "locations_counties", ["county_id"], "counties", ["id"], :name => "locations_counties_ibfk_2"

  add_foreign_key "locations_states", ["location_id"], "locations", ["id"], :name => "locations_states_ibfk_1"

  add_foreign_key "plans", ["agency_id"], "agencies", ["id"], :name => "plans_ibfk_1"

  add_foreign_key "plans_cities", ["plan_id"], "plans", ["id"], :name => "plans_cities_ibfk_1"
  add_foreign_key "plans_cities", ["city_id"], "cities", ["id"], :name => "plans_cities_ibfk_2"

  add_foreign_key "plans_counties", ["plan_id"], "plans", ["id"], :name => "plans_counties_ibfk_1"
  add_foreign_key "plans_counties", ["county_id"], "counties", ["id"], :name => "plans_counties_ibfk_2"

  add_foreign_key "plans_states", ["plan_id"], "plans", ["id"], :name => "plans_states_ibfk_1"

  add_foreign_key "plans_zips", ["plan_id"], "plans", ["id"], :name => "plans_zips_ibfk_1"

  add_foreign_key "publications", ["plan_id"], "plans", ["id"], :name => "publications_ibfk_1"

end
