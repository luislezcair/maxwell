class Ability
  include CanCan::Ability

  def initialize(user)
    return can(:manage, :all) if user.group.admin?

    group_permissions = user.group.group_permissions

    group_permissions.each do |gp|
      model = gp.permission.code.classify.constantize
      set_perms_for(model, gp)
    end
  end

  def set_perms_for(model, perm)
    if perm.view?
      can :read, model
    elsif perm.create?
      can [:read, :create], model
    elsif perm.edit?
      can [:read, :create, :update], model
    elsif perm.edit_delete?
      can :manage, model
    end
  end
end
