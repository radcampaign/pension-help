class RemoveNetworkUsersAndNetworkUserRole < ActiveRecord::Migration
  def change
    User.all.each do |user|
      user.roles.each do |role|
        if(role.role_name == 'NETWORK_USER')
          user.destroy
        end
      end
    end

    Role.all.each do |role|
      if(role.role_name == 'NETWORK_USER')
        role.destroy
      end
    end

  end
end
