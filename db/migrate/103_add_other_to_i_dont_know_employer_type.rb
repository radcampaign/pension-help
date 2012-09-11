class AddOtherToIDontKnowEmployerType < ActiveRecord::Migration
  def self.up
    execute "UPDATE employer_types SET name = 'Other / I don''t know' WHERE id=9"
  end

  def self.down
    execute "UPDATE employer_types SET name = 'I don''t know' WHERE id=9"
  end
end
