# frozen_string_literal: true

# Clase que define los permisos para los grupos de usuarios
#
# Tenemos permisos especiales para organizaciones. Si el grupo está asociado a
# una `organization`, solamente va a poder acceder a los registros que tengan
# esa misma `organization`. Por ejemplo: un TechnicalService con
# `organization_id == 1` va a poder ser accedido por grupos de usuarios que
# tengan `organization_id = nil` o `organization_id = 1`.
#
# Los grupos admin siempre tienen acceso total a todo.
#
class Ability
  include CanCan::Ability

  def initialize(user)
    group = user.group

    if group.admin?
      can(:manage, :all)
      return
    end

    group_org = group.organization

    group.group_permissions.each do |gp|
      perm = gp.permission
      model = perm.code.classify.constantize

      if perm.organization_filter && group_org.present?
        set_perms_for_organization(model, gp, group_org)
      else
        set_perms_for(model, gp)
      end
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

  def set_perms_for_organization(model, perm, org)
    if perm.view?
      can :read, model, organization_id: org.id
    elsif perm.create?
      can [:read, :create], model, organization_id: org.id
    elsif perm.edit?
      can [:read, :create, :update], model, organization_id: org.id
    elsif perm.edit_delete?
      can :manage, model, organization_id: org.id
    end
  end
end
