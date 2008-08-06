class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :role_name, :string
      t.column :description, :string
    end

    create_table :roles_users, :id => false do |t|
      t.column :user_id, :integer
      t.column :role_id, :integer
    end

    role = Role.new
    role.role_name = 'ADMIN'
    role.save!

    role = Role.new
    role.role_name = 'NETWORK_USER'
    role.save!

    #assign admin role to all exisiting users(non of are registers ones).
    User.find(:all).each do |u|
      u.roles << Role.find_by_role_name(ADMIN_ROLE)
    end
  end

  def self.down
    drop_table :roles
    drop_table :roles_users
  end
end
