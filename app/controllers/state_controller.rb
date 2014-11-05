class StateController < ApplicationController
  before_filter :authenticate_user!, :authorized?

  def authorized?
    current_user.is_admin?
  end

  def index
    @states=State.all
  end

  def catchall_employees
    @plan_employees=State.find(params[:id]).catchall_employees
  end

  def sort_catchall_employee
    params[:catchall_employee_list].each_with_index { |id,idx| PlanCatchAllEmployee.update(id, :position => idx) unless id.blank?}
    render :nothing => 'true'
  end
  
end
