class StateController < ApplicationController
    before_filter :login_required
    
  def index
    @states=State.find(:all)
  end

  def catchall_employees
    @plan_employees=State.find(params[:id]).catchall_employees
  end

  def sort_catchall_employee
    params[:catchall_employee_list].each_with_index { |id,idx| PlanCatchAllEmployee.update(id, :position => idx) unless id.blank?}
    render :nothing => 'true'
  end
  
end
