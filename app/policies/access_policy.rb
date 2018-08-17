class AccessPolicy
  include AccessGranted::Policy

  def configure

    role :admin, proc { |user| user.admin? } do
      # permissions for admin role 
      can [:read, :create, :update, :destroy], User
      can [:read, :create, :update, :destroy], Trip
    end

    role :member, proc { |user| user.member? } do
      # permissions for member role 
      can :create, Trip
      can :read, Trip do |trip, user|
        trip.user_id == user.id
      end
      can [:update, :destroy], Trip do |trip,user|
        trip.user_id == user.id
      end
      can [:update, :destroy], User do |current_user,user|
        current_user.id == user.id
      end

    end

  end
end