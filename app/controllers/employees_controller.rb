class EmployeesController < ApplicationController
  # refactor this controller code to work on per company basis
  # @company.employees.new
  
  before_action :set_company 
  before_action :set_employee, only: %i[ show edit update destroy ]
  
  def index
    #@employees = @company.employees
    @q = @company.employees.ransack(params[:q])
    @employees = @q.result(distinct: true)
  end

  def show
  end

  def new
    @employee = @company.employees.new
  end

  def edit
    if current_user.has_role? :company_admin
    else
    authorize! :update, @employee
    end
  end

  def create
    @employee = @company.employees.new(employee_params)

    #respond_to do |format|
      if @employee.save
        if current_user.has_role? :superadmin

          redirect_to company_employee_url(@company, @employee), notice: "Employee has been successfully created." 

        elsif current_user.has_role? :company_admin
          redirect_to company_admin_company_employees_url(@company), notice: "Employee of the company has been created by Company Admin."

        elsif current_user.has_role? :admin
          redirect_to admin_company_employees_url(current_user, @company), notice: "Employee of the company has been created by Admin."
        end  
      else
          render :new, status: :unprocessable_entity  
      end
  end

  def update
    
      if @employee.update(employee_params)
        if current_user.has_role? :superadmin
           redirect_to company_employee_url(@company, @employee), notice: "Employee has been successfully updated by superadmin." 
        
        elsif current_user.has_role? :company_admin
          redirect_to company_admin_company_employee_url(@company, @employee), notice:"Employee of the Company is successfully updated by Company Admin." 
        
        elsif current_user.has_role? :admin
          redirect_to admin_company_employee_url(current_user, @company, @employee), notice:"Employee of the Company is successfully updated by Admin." 
        end
      else
         render :edit, status: :unprocessable_entity 
      end
    end


  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to company_employees_url, notice: "Employee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_employee
      @employee = @company.employees.find(params[:id])
    end

    def set_company
      if current_user.has_role? :company_admin
        @company = Company.find(current_user.company.id)
      else  
        @company = Company.find(params[:company_id])
      end
    end

    def employee_params
      params.require(:employee).permit(:company_id, :name, :last_name, :email, :address, :designation, :city, :mob_no, :salary, :technology, :image)
    end
end
