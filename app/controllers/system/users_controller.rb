# frozen_string_literal: true

# Controlador para CRUD de usuarios.
#
class System::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /users
  def index
    @q = User.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @users = @q.result.page(params[:page])
  end

  # GET /system/users/new
  def new
    @user = User.new
  end

  # GET /system/users/1
  def show; end

  # GET /system/users/1/edit
  def edit; end

  # POST /system/users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to [:system, @user]
    else
      render :new, alert: :error
    end
  end

  # PUT/PATCH /system/users/1
  def update
    if @user.update(user_params)
      # Si se cambian las credenciales de acceso del usuario actual hay que
      # volver a loguearlo.
      bypass_sign_in(@user) if @user.eql?(current_user)
      redirect_to [:system, @user]
    else
      render :edit, alert: :error
    end
  end

  # DELETE /system/users/1
  def destroy
    destroy_model(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    remove_password_if_blank

    params.require(:user)
          .permit(:firstname, :lastname, :username, :email, :active, :password,
                  :password_confirmation, :group_id, :technician_id)
  end

  # Si los campos Contraseña y confirmar contraseña están en blanco, los quita
  # de la lista de parámetros para que se pueden actualizar los otros campos sin
  # ingresar una contraseña cada vez.
  #
  def remove_password_if_blank
    if params[:user][:password].blank? &&
       params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end
end
