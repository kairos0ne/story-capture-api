class AccessPolicy
  include AccessGranted::Policy

  def configure

    role :admin, proc { |user| user.admin? } do
      # permissions for admin role 
      can [:read, :create, :update, :destroy], User
      can [:read, :create, :update, :destroy], Trip
      can [:read, :create, :update, :destroy], Todo
      can [:read, :create, :update, :destroy], Destination
      can [:read, :create, :update, :destroy], Booking

    end

    role :member, proc { |user| user.member? } do
      # permissions for member role 
      can [:update, :destroy], User do |current_user,user|
        user.id == current_user.id
      end

    end

  end
end
