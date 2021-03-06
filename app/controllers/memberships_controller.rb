class MembershipsController < ApplicationController
  # only allow access to this controller if a user is signed in
  #
  # this should come before other callbacks so as to avoid errors popping up
  before_action :authenticate_user!
  before_action :set_membership, only: [:destroy]
  before_action :set_organization
  before_action :set_users, only: [:new]

  # GET organization/1/memberships/new
  def new
    @membership = Membership.new(organization: @organization)
  end

  # POST organization/1/memberships
  def create
    @membership = Membership.new(membership_params.merge organization: @organization)
    respond_to do |format|
      if @membership.save
        flash[:success] = 'User was successfully added.'
        format.html { redirect_to @organization }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # DELETE /memberships/1
  def destroy
    if @organization.users.size > 1
      @user = @membership.user
      @membership.destroy
      respond_to do |format|
        if @user == current_user
          format.html { redirect_to root_url }
        else
          format.html { redirect_to @organization }
        end
      end
    else
      respond_to do |format|
        flash[:alert] = 'You are the only member of this organization, so you must delete the organization instead of leaving it.'
        format.html { redirect_to @organization }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = current_user.organizations.find(params[:organization_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_users
      @users = User.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:user_id)
    end
end
