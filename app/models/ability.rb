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

      custom_actions = perm.special_actions
      custom_attrs = custom_attributes(perm, group_org)

      set_perms_for(model, gp, custom_attrs, custom_actions)
    end
  end

  def set_perms_for(model, perm, custom_attrs, custom_actions)
    if perm.view?
      can :read, model, custom_attrs
    elsif perm.create?
      can [:read, :create], model, custom_attrs
    elsif perm.edit?
      can [:read, :create, :update], model, custom_attrs
    elsif perm.edit_delete?
      can :manage, model, custom_attrs
    end

    custom_actions.each do |action, permission|
      custom_value = GroupPermission.permission_value(permission)
      perm_value = perm.permission_code_value

      can action, model, custom_attrs if custom_value <= perm_value
    end
  end

  def custom_attributes(perm, group_org)
    return {} unless perm.organization_filter && group_org

    { organization_id: group_org.id }
  end
end
