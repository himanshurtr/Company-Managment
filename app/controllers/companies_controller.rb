class CompaniesController < ApplicationController

  before_action :set_company, only: [:show, :edit, :update, :destroy]
  
  def index
    #@companies = Company.all
    @q = Company.all.ransack(params[:q])
    @companies = @q.result(distinct: true)
  end

  def show  
  end

  def new
    @company = Company.new
  end

  def edit
    if current_user.has_role? :company_admin
      @company = Company.find([current_user.company.id])
    else    
     @company = Company.find(params[:id])
    end 
  end
  
  def root
    @company = Company.all
  end

  def service
  end

  def profile
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      if current_user.has_role? :superadmin
        redirect_to super_admin_companies_path, notice:"Company is successfully created."
      elsif current_user.has_role? :admin
        redirect_to admin_companies_path(current_user.id), notice: "Company is successfully created by Internal Admin"
      end 
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if current_user.has_role? :company_admin
      @company = Company.find(current_user.company.id)
    else     
      @company = Company.find(params[:id])
    end 
     
    if @company.update(company_params)
      if current_user.has_role? :admin
        redirect_to admin_companies_path(current_user), notice:"Company is successfully updated."
      elsif current_user.has_role? :superadmin
        redirect_to super_admin_companies_path, notice:"Company is successfully updated."
      elsif current_user.has_role? :company_admin
        redirect_to company_admin_company_path, notice:"Admin Company is successfully updated."     
      else   
      render :edit, status: :unprocessable_entity
      end
    end  
  end


  def destroy
    @company = Company.find(params[:id])

    @company.destroy

     if current_user.has_role? :superadmin
       redirect_to super_admin_companies_path, status: :see_other, notice: "Company is successfully deleted."

     else current_user.has_role? :admin
       redirect_to admin_companies_path, notice: "Company is successfully deleted by Internal Admin."
     end
  end

  private

    def company_params
      params.require(:company).permit(:name, :address, :city, :state, :phone_no, :pin_code, :technologies, :link, :linkdin, :instagram, :facebook, :image)
    end

    def set_company
      if current_user.has_role? :company_admin
        @company = Company.find([current_user.company.id])
      else
        #debugger
        @company = Company.find(params[:id])
      end      
    end
end
