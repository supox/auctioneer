class AuctionsController < ApplicationController
  before_filter :valid_auction, except: [:index, :new, :create]
	before_filter :signed_in_user
  before_filter :admin_user, only: [:create, :destroy]

  def index
  	@user = current_user
    @auctions = Auction.all

    respond_to do |format|
      format.html
      format.json { render json: @auctions }
    end
  end

  def show
	  @user = current_user
  	@add_to_mailing_list = @auction.listeners.include?(@user)
    respond_to do |format|
      format.html
      format.json { render json: @auction }
    end
  end

  def new
    @auction = Auction.new
    @auction.build_item
    @auction.date_opened = Time.now

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @auction }
    end
  end

  def edit
  end

  def create
    @auction = Auction.new(params[:auction])

    respond_to do |format|
      if @auction.save
        format.html { redirect_to @auction, notice: 'Auction was successfully created.' }
        format.json { render json: @auction, status: :created, location: @auction }
      else
        format.html { render action: "new" }
        format.json { render json: @auction.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @auction.update_attributes(params[:auction])
        format.html { redirect_to @auction, notice: 'Auction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @auction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @auction.destroy

    respond_to do |format|
      format.html { redirect_to auctions_url }
      format.json { head :no_content }
    end
  end
  
  protected
	def valid_auction
		id = params[:id]
    @auction = Auction.find(id)
    redirect_to(root_path) unless @auction    	
	end
end
