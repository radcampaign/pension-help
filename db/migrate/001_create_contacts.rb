class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.column "first_name", :string, :limit => 80
      t.column "last_name", :string, :limit => 80
      t.column "middle_initial", :string, :limit => 2
      t.column "company", :string
      t.column "line_1", :string
      t.column "line_2", :string
      t.column "city", :string, :limit => 50
      t.column "state_abbrev", :string, :limit => 2
      t.column "zip_code", :string, :limit => 10
      t.column "phone", :string, :limit => 20
      t.column "fax", :string, :limit => 20
      t.column "email", :string
      t.column "url", :string
      t.column "profession_id", :integer, :null => true, :references => nil
      t.column "profession_other", :string
      t.column "affiliations", :string
      t.column "wants_npln", :boolean
      t.column "wants_aaa", :boolean
    end
  end

  def self.down
    drop_table :contacts
  end
end
