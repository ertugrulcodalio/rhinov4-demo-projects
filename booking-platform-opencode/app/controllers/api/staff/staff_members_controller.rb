# frozen_string_literal: true

class Api::Staff::StaffMembersController < Api::Staff::BaseController
  before_action :authorize_staff_member, only: [:show, :update, :destroy]

  def index
    authorize StaffMember
    staff_members = policy_scope(StaffMember)
    render json: staff_members
  end

  def show
    render json: @staff_member
  end

  def create
    staff_member = current_organization.staff_members.new(staff_member_params)
    authorize staff_member
    
    if staff_member.save
      render json: staff_member, status: :created
    else
      render json: { errors: staff_member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @staff_member.update(staff_member_params)
      render json: @staff_member
    else
      render json: { errors: @staff_member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @staff_member.discard
    head :no_content
  end

  private

  def authorize_staff_member
    @staff_member = current_organization.staff_members.kept.find(params[:id])
    authorize @staff_member
  end

  def staff_member_params
    params.require(:staff_member).permit(:name, :role, :email, :phone, :active)
  end
end