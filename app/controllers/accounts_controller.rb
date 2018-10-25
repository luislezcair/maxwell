# frozen_string_literal: true

# Controlador para Plan de cuentas (/accounts)
#
class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :account_collection, only: [:new, :edit]
  authorize_resource

  # GET /accounts
  def index; end

  # GET /accounts/1
  def show; end

  # GET /accounts/new?parent_id=:id
  def new
    parent = params[:parent_id]
    @account = if parent
                 parent_acc = Account.find(parent)
                 @account = parent_acc.children.new
               else
                 Account.new
               end
  end

  # GET /accounts/1/edit
  def edit; end

  # PATCH /accounts/1
  def update
    if @account.update(account_params)
      render 'create'
    else
      account_collection
      render 'create_error'
    end
  end

  # POST /accounts
  def create
    @account = Account.new(account_params)
    return if @account.save

    account_collection
    render 'create_error'
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy
  rescue Ancestry::AncestryException
    @account.errors.add(:base, :children)
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :code, :imputable, :parent_id)
  end

  def account_collection
    @accounts = Account.order(:names_depth_cache).map do |a|
      ['-' * a.depth + ' ' + a.name, a.id]
    end
  end
end
