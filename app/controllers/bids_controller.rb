class BidsController < ApplicationController
  before_filter :valid_auction
	before_filter :signed_in_user
	before_filter :valid_bid, except: [:index, :new, :create]
  # GET /bids
  # GET /bids.json
  def index
    @bids = Bid.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bids }
    end
  end

  # GET /bids/1
  # GET /bids/1.json
  def show
  	respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bid }
    end
  end

  # GET /bids/new
  # GET /bids/new.json
  def new
    @bid = Bid.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bid }
    end
  end

  # GET /bids/1/edit
  def edit
  end

  # POST /bids
  # POST /bids.json
  def create
  	p = (params[:bid] || {}).merge({user:current_user})
  	begin
		  @bid = @auction.bid(p)

		  respond_to do |format|
		    if @bid.save
		      format.html { redirect_to @auction, notice: t(:bid_created) }
		      format.json { render json: @auction, status: :created, location: @bid }
		    else
		      format.html { render action: "new" }
		      format.json { render json: @bid.errors, status: :unprocessable_entity }
		    end
		  end
	  rescue Exception => e
	  	redirect_to @auction, notice: t(:auction_closed) if e.message == 'Auction Closed'
	  end
  end

  # PUT /bids/1
  # PUT /bids/1.json
  def update
    respond_to do |format|
      if @bid.update_attributes(params[:bid])
        format.html { redirect_to @auction, notice: 'Bid was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bids/1
  # DELETE /bids/1.json
  def destroy
    @bid.destroy

    respond_to do |format|
      format.html { redirect_to auction_bids_url(@auction) }
      format.json { head :no_content }
    end
  end
  
  protected
	def valid_auction
		id = params[:auction_id]
    @auction = Auction.find(id) 
    redirect_to(root_path) unless @auction    	
	end
	
	def valid_bid
		@bid = @auction.bids.find(params[:id])
		redirect_to(root_path) unless @bid
	end
	
end
