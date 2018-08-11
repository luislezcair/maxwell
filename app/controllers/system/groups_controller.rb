# frozen_string_literal: true

# Controlador para grupos de usuarios
#
class System::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /system/groups
  def index
    @q = Group.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @groups = @q.result.page(params[:page])
  end

  # GET /system/groups/new
  def new
    @group = Group.new
  end

  # GET /system/groups/1
  def show; end

  # GET /system/groups/1/edit
  def edit; end

  # POST /system/groups
  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to [:system, @group]
    else
      render :new, alert: :error
    end
  end

  # PUT/PATCH /system/groups/1
  def update
    if @group.update(group_params)
      redirect_to [:system, @group]
    else
      render :edit, alert: :error
    end
  end

  # DELETE /system/groups/1
  def destroy
    destroy_model(@group)
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group)
          .permit(:name, :organization_id,
                  group_permissions_attributes: [:id, :permission_id,
                                                 :permission_code])
  end
end
