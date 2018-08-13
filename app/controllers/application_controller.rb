# frozen_string_literal: true

# Controlador padre de todos los controladores. Define la configuración de
# Devise, Sentry y algunos métodos utilizados por varios controladores.
#
class ApplicationController < ActionController::Base
  before_action :set_raven_context
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |e|
    respond_to do |format|
      format.js { render 'shared/permission_error' }
      format.html { redirect_to unauthenticated_root_url, alert: e.message }
    end
  end

  protected

  def set_raven_context
    return unless ENV['SENTRY_ACTIVE'] == 'true'

    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation,
                   :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  # Devuelve true si hay parámetros de búsqueda definidos, false si no hay
  # parámetros o están vacíos.
  #
  def search_params?
    params[:q] && params[:q].reject { |_, v| v.blank? }.present?
  end

  # Comportamiento común cuando se elimina una entidad. Si se eliminó sin
  # problemas redirige al index.js correspondiente o a la dirección indicada en
  # el parámetro `redirect_to`. Si hubo un error, renderiza un alert con la
  # descripción del error.
  #
  def destroy_model(model)
    unless model.destroy
      @object = model
      render 'shared/destroy'
      return
    end

    redirect_to params[:return_to] || index_path_with_params,
                status: :see_other,
                flash: { alert: delete_success_msg }
  end

  # Contruye la URL para la acción index con los parámetros que vinieron en el
  # request. Esto se utiliza para redirigir utilizando los mismos parámetros que
  # vinieron en el request original.
  #
  def index_path_with_params
    path_helper = method("#{controller_path.tr('/', '_')}_path")
    path_helper.call(request.query_parameters[:page],
                     q: request.query_parameters[:q])
  end

  # Devuelve un mensaje por defecto al eliminar un modelo que se corresponde con
  # el controlador actual.
  #
  def delete_success_msg
    model = controller_name.singularize
    I18n.t('delete_success', scope: "activerecord.errors.models.#{model}")
  end
end
