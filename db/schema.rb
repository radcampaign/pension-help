# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 26) do

  create_table "addresses", :force => true do |t|
    t.column "location_id",    :integer
    t.column "line1",          :string
    t.column "line2",          :string
    t.column "city",           :string,  :limit => 64
    t.column "state_abbrev",   :string
    t.column "zip",            :string
    t.column "address_type",   :string
    t.column "legacy_code",    :string,  :limit => 10
    t.column "legacy_subcode", :string,  :limit => 10
    t.column "fmp2_code",      :string,  :limit => 10
  end

  add_index "addresses", ["location_id"], :name => "location_id"

  create_table "agencies", :force => true do |t|
    t.column "agency_category_id", :integer
    t.column "result_type_id",     :integer
    t.column "name",               :string
    t.column "name2",              :string
    t.column "description",        :text
    t.column "data_source",        :string
    t.column "is_active",          :boolean
    t.column "url",                :string
    t.column "url_title",          :string
    t.column "url2",               :string
    t.column "url2_title",         :string
    t.column "comments",           :text
    t.column "services_provided",  :text
    t.column "use_for_counseling", :boolean
    t.column "created_at",         :datetime
    t.column "updated_at",         :datetime
    t.column "updated_by",         :string
    t.column "legacy_code",        :string,   :limit => 10
    t.column "legacy_status",      :string
    t.column "legacy_category1",   :string
    t.column "legacy_category2",   :string
    t.column "fmp2_code",          :string,   :limit => 10
  end

  add_index "agencies", ["agency_category_id"], :name => "agency_category_id"
  add_index "agencies", ["result_type_id"], :name => "result_type_id"

  create_table "agency_categories", :force => true do |t|
    t.column "name",     :string
    t.column "position", :integer
  end

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
    t.column "agency_id",          :integer
    t.column "name",               :string
    t.column "name2",              :string
    t.column "is_hq",              :boolean
    t.column "is_provider",        :boolean
    t.column "tollfree",           :string,   :limit => 20
    t.column "tollfree_ext",       :string,   :limit => 10
    t.column "phone",              :string,   :limit => 20
    t.column "phone_ext",          :string,   :limit => 10
    t.column "tty",                :string,   :limit => 20
    t.column "tty_ext",            :string,   :limit => 10
    t.column "fax",                :string,   :limit => 20
    t.column "email",              :string
    t.column "hours_of_operation", :string
    t.column "logistics",          :string
    t.column "updated_at",         :datetime
    t.column "legacy_code",        :string,   :limit => 10
    t.column "legacy_subcode",     :string,   :limit => 10
    t.column "fmp2_code",          :string,   :limit => 10
    t.column "updated_by",         :string
  end

  add_index "locations", ["agency_id"], :name => "agency_id"

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

  create_table "plans", :force => true do |t|
    t.column "agency_id",          :integer
    t.column "name",               :string
    t.column "name2",              :string
    t.column "description",        :text
    t.column "comments",           :text
    t.column "start_date",         :date
    t.column "end_date",           :date
    t.column "covered_employees",  :text
    t.column "catchall_employees", :text
    t.column "plan_type1",         :string
    t.column "plan_type2",         :string
    t.column "plan_type3",         :string
    t.column "url",                :string
    t.column "url_title",          :string
    t.column "admin_url",          :string
    t.column "admin_url_title",    :string
    t.column "tpa_url",            :string
    t.column "tpa_url_title",      :string
    t.column "spd_url",            :string
    t.column "spd_url_title",      :string
    t.column "govt_employee_type", :string
    t.column "fmp2_code",          :string
    t.column "legacy_category",    :string
    t.column "legacy_status",      :string
    t.column "updated_at",         :datetime
    t.column "updated_by",         :string
    t.column "email",              :string
  end

  add_index "plans", ["agency_id"], :name => "agency_id"

  create_table "professions", :force => true do |t|
    t.column "name",     :string
    t.column "position", :integer
  end

  create_table "publications", :force => true do |t|
    t.column "agency_id",    :integer
    t.column "tollfree",     :string,  :limit => 20
    t.column "tollfree_ext", :string,  :limit => 10
    t.column "phone",        :string,  :limit => 20
    t.column "phone_ext",    :string,  :limit => 10
    t.column "tty",          :string,  :limit => 20
    t.column "tty_ext",      :string,  :limit => 10
    t.column "fax",          :string,  :limit => 20
    t.column "email",        :string
    t.column "url",          :string
    t.column "url_title",    :string
    t.column "legacy_code",  :string,  :limit => 10
    t.column "fmp2_code",    :string,  :limit => 10
  end

  add_index "publications", ["agency_id"], :name => "agency_id"

  create_table "restrictions", :force => true do |t|
    t.column "agency_id",          :integer
    t.column "location_id",        :integer
    t.column "plan_id",            :integer
    t.column "minimum_age",        :decimal,                :precision => 5, :scale => 2
    t.column "max_poverty",        :decimal,                :precision => 5, :scale => 2
    t.column "special_district",   :string
    t.column "other_restrictions", :text
    t.column "created_at",         :datetime
    t.column "updated_at",         :datetime
    t.column "legacy_geo_type",    :string
    t.column "legacy_geo_states",  :string
    t.column "legacy_geo_other",   :text
    t.column "legacy_code",        :string,   :limit => 10
    t.column "legacy_subcode",     :string,   :limit => 10
    t.column "fmp2_code",          :string,   :limit => 10
  end

  add_index "restrictions", ["agency_id"], :name => "agency_id"
  add_index "restrictions", ["location_id"], :name => "location_id"
  add_index "restrictions", ["plan_id"], :name => "plan_id"

  create_table "restrictions_cities", :id => false, :force => true do |t|
    t.column "restriction_id", :integer, :null => false
    t.column "city_id",        :integer, :null => false
  end

  add_index "restrictions_cities", ["city_id", "restriction_id"], :name => "index_restrictions_cities_on_city_id_and_restriction_id"

  create_table "restrictions_counties", :id => false, :force => true do |t|
    t.column "restriction_id", :integer, :null => false
    t.column "county_id",      :integer, :null => false
  end

  add_index "restrictions_counties", ["county_id", "restriction_id"], :name => "index_restrictions_counties_on_county_id_and_restriction_id"

  create_table "restrictions_states", :id => false, :force => true do |t|
    t.column "restriction_id", :integer,              :null => false
    t.column "state_abbrev",   :string,  :limit => 2, :null => false
  end

  add_index "restrictions_states", ["state_abbrev", "restriction_id"], :name => "index_restrictions_states_on_state_abbrev_and_restriction_id"

  create_table "restrictions_zips", :id => false, :force => true do |t|
    t.column "restriction_id", :integer,              :null => false
    t.column "zipcode",        :string,  :limit => 5, :null => false
  end

  add_index "restrictions_zips", ["zipcode", "restriction_id"], :name => "index_restrictions_zips_on_zipcode_and_restriction_id"

  create_table "result_types", :force => true do |t|
    t.column "name",     :string
    t.column "position", :integer
  end

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
    t.column "county_id",    :integer
  end

  add_index "zips", ["county_id"], :name => "county_id"

  add_foreign_key "addresses", ["location_id"], "locations", ["id"], :name => "addresses_ibfk_1"

  add_foreign_key "agencies", ["agency_category_id"], "agency_categories", ["id"], :name => "agencies_ibfk_1"
  add_foreign_key "agencies", ["result_type_id"], "result_types", ["id"], :name => "agencies_ibfk_2"

  add_foreign_key "cities", ["county_id"], "counties", ["id"], :name => "cities_ibfk_1"

  add_foreign_key "images", ["parent_id"], "images", ["id"], :name => "images_ibfk_1"

  add_foreign_key "locations", ["agency_id"], "agencies", ["id"], :name => "locations_ibfk_1"

  add_foreign_key "plans", ["agency_id"], "agencies", ["id"], :name => "plans_ibfk_1"

  add_foreign_key "publications", ["agency_id"], "agencies", ["id"], :name => "publications_ibfk_1"

  add_foreign_key "restrictions", ["agency_id"], "agencies", ["id"], :name => "restrictions_ibfk_1"
  add_foreign_key "restrictions", ["location_id"], "locations", ["id"], :name => "restrictions_ibfk_2"
  add_foreign_key "restrictions", ["plan_id"], "plans", ["id"], :name => "restrictions_ibfk_3"

  add_foreign_key "restrictions_cities", ["restriction_id"], "restrictions", ["id"], :name => "restrictions_cities_ibfk_1"
  add_foreign_key "restrictions_cities", ["city_id"], "cities", ["id"], :name => "restrictions_cities_ibfk_2"

  add_foreign_key "restrictions_counties", ["restriction_id"], "restrictions", ["id"], :name => "restrictions_counties_ibfk_1"
  add_foreign_key "restrictions_counties", ["county_id"], "counties", ["id"], :name => "restrictions_counties_ibfk_2"

  add_foreign_key "restrictions_states", ["restriction_id"], "restrictions", ["id"], :name => "restrictions_states_ibfk_1"

  add_foreign_key "restrictions_zips", ["restriction_id"], "restrictions", ["id"], :name => "restrictions_zips_ibfk_1"

  add_foreign_key "zips", ["county_id"], "counties", ["id"], :name => "zips_ibfk_1"

end
