class AddColumnsToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :parent_id, :integer
    add_column :contents, :lft, :integer
    add_column :contents, :rgt, :integer
    add_column :contents, :is_active, :boolean

    #add root category, which not be visible,
    execute %{insert into contents(id, url,title,content) values (1, 'Root', 'Root', 'Root')}

    #Home category
    execute %{update contents set parent_id = 2 where id = 3} #about-us
    execute %{update contents set parent_id = 2 where id = 4} #disclaimers
    execute %{update contents set parent_id = 2 where id = 6} #privacy
    execute %{update contents set parent_id = 2 where id = 7} #terms_of_use
    execute %{update contents set parent_id = 2 where id = 8} #copyright
    #Search category
    execute %{update contents set parent_id = 10 where id = 11} #search/pbgc
    execute %{update contents set parent_id = 10 where id = 12} #search/free_erisa
    execute %{update contents set parent_id = 10 where id = 13} #search/corporate_affiliations
    execute %{update contents set parent_id = 10 where id = 14} #search/pension_booklet
    #Pals category
    execute %{update contents set parent_id = 9 where id = 15} #pals/service_partners
    execute %{update contents set parent_id = 9 where id = 16} #pals/funding_partners
    execute %{update contents set parent_id = 9 where id = 17} #pals/founding_partners
    execute %{update contents set parent_id = 9 where id = 18} #pals/how_to_help
    #Help category
    execute %{update contents set parent_id = 5 where id = 19} #help/counseling
    execute %{update contents set parent_id = 5 where id = 20} #help/resources

    execute %{update contents set parent_id = 1 where id = 2} #help/resources
    execute %{update contents set parent_id = 1 where id = 5} #help/resources
    execute %{update contents set parent_id = 1 where id = 9} #help/resources
    execute %{update contents set parent_id = 1 where id = 10} #help/resources

    Content.renumber_all
    
    Content.update_all "is_active = 1", "id <> 1" 
  end

  def self.down
    remove_column :contents, :parent_id
    remove_column :contents, :lft
    remove_column :contents, :rgt
    remove_column :contents, :is_active
  end
end
