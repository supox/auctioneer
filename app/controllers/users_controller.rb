class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index]
	before_filter :correct_user, except:[:index, :new, :create, :forgot, :reset]
  before_filter :admin_user, only: [:destroy]
	
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
      	sign_in @user
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  def forgot
    if request.post?
      user = User.find_by_email(params[:user][:email])
      if user
        user.create_reset_code
        flash[:notice] = I18n.t("reset_code_sent_to", email: user.email)
        redirect_back_or('/')
      else
        flash[:error] = I18n.t("mail_does_not_exist_in_system", email: params[:user][:email])
      end
    end
  end
  
  def reset
    @reset_code = params[:reset_code]
    @user = User.find_by_reset_password_token(@reset_code) unless @reset_code.nil?
  
    if @user.nil?
	    redirect_back_or('/') 
	    return
    end
	    
    if request.put?
      if @user.reset_password(@reset_code, params[:user][:password], params[:user][:password_confirmation])
        sign_in @user
        flash[:success] = t(:password_has_been_reset_successfully)
        redirect_to @user
      else
        render :action => :reset
      end
    end
  end
  
  protected
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user) || signed_in? && current_user.admin?
  end

end

