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
    @user = User.new(user_params)

    if @user.save

      if current_user.has_role? :superadmin
        if request.path == super_admin_users_path
          redirect_to super_admin_users_path(@company, @user), notice: "user is successfully created."
        elsif request.path == super_admin_company_users_path
          redirect_to super_admin_company_users_path(@company), notice: "Company admin is successfully created by superadmin "
        end 
      end 

      if current_user.has_role? :admin
        redirect_to admin_company_users_path(@company, @user), notice: "User Whoes Roll Is Admin Created Successfully."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update

    if @user.update(user_params)

      if current_user.has_role? :superadmin
        if request.path == super_admin_user_path
          redirect_to super_admin_users_path(@company, @user), notice: "user was successfully updated."
        elsif request.path == super_admin_company_user_path
          redirect_to super_admin_company_users_path(@company), notice:"Company admin is successfully updated by superadmin "
        end
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
      if current_user.has_role? :superadmin
        if request.path == super_admin_user_path
          redirect_to super_admin_users_path, status: :see_other, notice:"User is successfully deleted."
        elsif request.path == super_admin_company_user_path(@company)
          redirect_to super_admin_company_users_path(@company), notice:"Company admin is successfully deleted by superadmin "
        end
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
