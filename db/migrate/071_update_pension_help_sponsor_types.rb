class UpdatePensionHelpSponsorTypes < ActiveRecord::Migration
  def self.up
    execute "alter table sponsor_types add column use_for_search tinyint(1) default 0"
    execute "update sponsor_types set use_for_search=1 where name like 'Single-employer%'"
    execute "update sponsor_types set use_for_search=1 where name like 'Multiemployer%'"
    execute "update sponsor_types set use_for_search=1 where name like 'Multiple-employer%'"
    execute "update sponsor_types set use_for_search=1 where name like 'Religious%'"

    execute "alter table sponsor_types add column use_for_npln tinyint(1) default 1"
    execute "alter table sponsor_types add column use_for_help tinyint(1) default 1"
    execute "alter table sponsor_types drop column use_for_pal_only"
    execute "update sponsor_types set use_for_npln=0, use_for_help=0, use_for_search=0 where name like 'Federal government%'"
    
    add_column :partners, :willing_to_provide_plan_info, :boolean
  end

  def self.down
    remove_column :partners, :willing_to_provide_plan_info
  end
end
