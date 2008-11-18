class AddCurrentlyEmployedToCounseling < ActiveRecord::Migration
  def self.up
    add_column :counselings, :currently_employed, :boolean
    c=Content.new
    c.title = "Text for currently employed users"
    c.url = "currently_employed_text"
    c.is_active = true
    c.content = "<h1>Current employees should consider first contacting their personnel office or retirement plan administrator.</h1>"
    c.save!
    c.move_to_child_of(Content.root)
  end

  def self.down
    remove_column :counselings, :currently_employed
    Content.find_by_url('currently_employed_text').destroy
  end
end
