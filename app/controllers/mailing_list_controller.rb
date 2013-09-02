class MailingListController < ApplicationController
  before_filter :valid_auction
	before_filter :signed_in_user

  def create
  	@user = current_user
		@auction.listeners << @user unless @auction.listeners.include?(@user)
	  respond_to do |format|
	    if @auction.save
	      format.html { redirect_to @auction, notice: "Added to mailing list." }
	      format.js# on { render json: @auction, status: :created, location: @auction }
	    else
	      format.html { redirect_to @auction, notice: "Unknown error." }
	      format.json { render json: @auction.errors, status: :unprocessable_entity }
	    end
	  end
  end

  def destroy
  	@user = current_user
		@auction.listeners.delete(@user) if @auction.listeners.include?(@user)

    respond_to do |format|
      format.html { redirect_to @auction, notice: "Removed to mailing list." }
      format.js
    end
  end
  
	protected
	def valid_auction
		id = params[:auction_id]
    @auction = Auction.find(id) 
    redirect_to(root_path) unless @auction    	
	end
	  
end
