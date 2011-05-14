class AddFarmCreditOption < ActiveRecord::Migration
  def self.up
    execute "UPDATE employer_types set position = position + 1 where position >= 4"
    execute "INSERT INTO employer_types (id, name, position) VALUES (10, 'Farm Credit District, Bank or System Affiliate', 4)"
    execute "INSERT INTO result_types (name, position) VALUES ('FCD', 22)"
    execute "UPDATE agency_categories set position = position + 1 where position >= 3"
    execute "INSERT INTO agency_categories (id, name, position) VALUES (6, 'Farm Credit Plan', 3)"
  end

  def self.down
    execute "DELETE FROM agency_categories where id=6"
    execute "UPDATE agency_categories set position = position - 1 where position > 3"
    execute "DELETE FROM result_types where name = 'FCD'"
    execute "DELETE FROM employer_types where name like 'Farm Credit%'"
    execute "UPDATE employer_types set position = position - 1 where position > 4"
  end
end