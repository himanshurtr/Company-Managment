class UsersController < ApplicationController
  before_action :set_company
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  
  def index
    #@users = User.all
    @q = User.all.ransack(params[:q])
    @users = @q.result(distinct: true)    
  end

  def new
    @user = User.new
  end

  def show

  end

  def edit
  end

  def create
    # debugger
    @user = User.new(user_params)

    if @user.save

      if current_user.has_role? :superadmin
        redirect_to super_admin_users_path(@company, @user), notice: "user is successfully created."
      else
        redirect_to admin_company_users_path(@company, @user), notice: "User Whoes Roll Is Admin Created Successfully."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update

    if @user.update(user_params)
      redirect_to super_admin_users_path(@company, @user), notice: "user was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
      if current_user.has_role? :superadmin
        redirect_to super_admin_users_path, status: :see_other, notice:"User is successfully deleted."
      else
        redirect_to admin_company_users_path(current_user.id, @company), status: :see_other, notice:"Admin User is successfully deleted." 
      end
  end


    private

    def set_user
     @user = User.find(params[:id])
    end

    def set_company
     @company = Company.find_by(id: params[:company_id])
    end


    def user_params
      params.require(:user).permit(:company_id, :email, :password, :role_ids, :image)
    end

end
