class SuperAdminsController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @users = User.all
  end

  
  def new
    @user = User.new
  end

  
  def show
    
  end


  def edit
    
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to super_admins_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update

    if @user.update(user_params)
      redirect_to super_admins_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy

    redirect_to super_admins_path, status: :see_other
  end


  private

    def set_user
     @user = User.find(params[:id])
    end


    def user_params
      params.require(:user).permit(:email, :password)
    end


end
