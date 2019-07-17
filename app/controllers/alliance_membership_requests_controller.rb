class AllianceMembershipRequestsController < ApplicationController

  # POST /alliance_membership_requests
  # POST /alliance_membership_requests.json
  def create
    @alliance_membership_request = AllianceMembershipRequest.new(alliance_membership_request_params)
    @alliance_membership_request.user = current_user
    respond_to do |format|
      if @alliance_membership_request.save
        format.html { redirect_to aliances_path, notice: 'Alliance membership request was successfully created.' }
      else
        format.html { redirect_to aliances_path, alert: 'Error occured. Try it again please.' }
      end
    end
  end

  # DELETE /alliance_membership_requests/1
  # DELETE /alliance_membership_requests/1.json
  def destroy
    @alliance_membership_request = AllianceMembershipRequest.find(params[:id])
    @alliance_membership_request.destroy
    respond_to do |format|
      format.html { redirect_to aliances_path, notice: 'Alliance membership request was successfully cancelled.' }
    end
  end

  def accept
    @alliance_membership_request = AllianceMembershipRequest.find(params[:id])
    @alliance_membership_request.user.aliance = @alliance_membership_request.aliance
    @alliance_membership_request.user.save!
    @alliance_membership_request.destroy!
    
    respond_to do |format|
      format.html { redirect_to aliances_path, notice: 'Alliance membership request was successfully accepted.' }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def alliance_membership_request_params
      params.permit(:user_id, :aliance_id)
    end
end
