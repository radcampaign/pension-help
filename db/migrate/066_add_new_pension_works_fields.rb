class AddNewPensionWorksFields < ActiveRecord::Migration
  def self.up
    execute 'truncate partners_plan_types'
    execute 'truncate plan_types'
    execute 'alter table plan_types add column use_for_pal tinyint(1)'
    execute "insert into plan_types (name, position, use_for_pal) values 
            ('Pension Benefits', 1, 1), 
            ('Profit Sharing and Defined Contribution Benefits', 2, 1),
            ('Individual Plans (IRA, Keough, SEP)',3 ,1 ),
            ('Disability Benefits', 4, 0),
            ('Healthcare & COBRA Benefits', 5, 0),
            ('Benefits Discrimination / Interference', 6, 0),
            ('Executive Compensation Benefits', 7, 0),
            ('Domestic Relations Orders', 8, 0),
            ('Other', 9, 1)"
    
    execute "alter table sponsor_types add column use_for_pal tinyint(1) default 1"
    execute "alter table sponsor_types add column use_for_pal_only tinyint(1) default 0"
    execute "update sponsor_types set name='Federal Government entities', use_for_pal_only=1 where name='Federal government'"
    execute "update sponsor_types set name='Religious Institution' where name='Church plans'"
    execute "update sponsor_types set position = position + 1 where position > 3"
    execute "update sponsor_types set position=4 where name='Religious Institution'"
    execute "update sponsor_types set name='Defense Finance and Accounting Service', position=9, use_for_pal=0  where name='Military'"
    execute "update sponsor_types set name='Railroad Retirement Board', position=10, use_for_pal=0 where name='Railroad'"
    execute "update sponsor_types set name='State, county and local plans', position=11 where name='State, county and other government plans'"
    execute "update sponsor_types set position=12 where name='Other:'"
    execute "insert into sponsor_types (name, position, use_for_pal) values 
             ('Pension Benefit Guaranty Corporation', 6, 0),
             ('Office of Personnel Management', 7, 0),
             ('Merit Systems Protection Board', 8, 0)"
         
    execute "insert into npln_additional_areas (name, position) values ('Contracts', 1)"
    execute "insert into npln_additional_areas (name, position) values ('Domestic Relations', 2)"
    execute "update npln_additional_areas set name = 'Employment', position = 3 where name = 'Employment Law'"
    execute "update npln_additional_areas set name = 'Labor', position = 4 where name = 'Labor Law'"
    execute "insert into npln_additional_areas (name, position) values ('Medicare / Medicaid', 5)"
    execute "update npln_additional_areas set position = 6 where name = 'Social Security'"
    execute "update npln_additional_areas set position = 7 where name = 'Veterans Benefits'"
    execute "insert into npln_additional_areas (name, position) values ('Wills and Trusts', 8)"
    execute "update npln_additional_areas set position = 9 where name = 'Other:'"
    
       
  end

  def self.down
    remove_column :plan_types, :use_for_pal
    remove_column :sponsor_types, :heading  
  end
end
