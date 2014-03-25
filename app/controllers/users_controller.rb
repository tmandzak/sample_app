class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
    #@users = User.all    #without pagination
  end

  def new
  	@user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)  #not @user = User.new(params[:user]) !!!
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"	
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    # @user = User.find(params[:id])   #not needed since defined in before_action :correct_user
  end

  def update
    #@user = User.find(params[:id])    #not needed since defined in before_action :correct_user
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # def signed_in_user  #Moved to SessionHelper to be accessible for MicropostsController
    #   unless signed_in?
    #     store_location
    #     flash[:notice] = "Please sign in."
    #     redirect_to signin_url
    #   end

    #   # redirect_to signin_url, notice: "Please sign in." unless signed_in?
    # end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
