class Ability
  include CanCan::Ability

  def initialize(user)

    user_roles = user.roles
    user_roles = Role.where(:name => User::ROLE[:GUEST]) if user_roles.blank?

    user_permissions = Role.where(:id=> user_roles.collect(&:id)).joins(:permissions).select("permissions.*")


    # permissions = user.permissions.select("permissions.name, permissions.model_name").collect{|p| [p.name, p.model_name]}
    # Iterate over uniq permissions
    user_permissions.uniq.each do |permission|
      p = permission.name.to_s
      begin
        object = permission.model_name.constantize
      rescue NameError
        object = :all
      end
      can p, object
    end

    can :read, Article, :published => true

    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

  def can? permission, object
    super(permission.to_s, object)
  end

  def cannot? permission, object
    super(permission.to_s, object)
  end

end
