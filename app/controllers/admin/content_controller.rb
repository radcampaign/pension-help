class Admin::ContentController < ApplicationController
  before_filter :authenticate_user!, :authorized?
  
  def authorized?
    redirect_to(root_path) unless current_user.is_admin?
  end

  def index
    list
    render :action => 'list'
  end

  def list
    #collec = Content.root.children
    @contents = Content.root.children.paginate(:page => params[:page]).per_page(20)
  end

  def show
    @content = Content.find(params[:id])
  end

  def new
    @content = Content.new
    @content.is_active = true
  end

  def create
    @content = Content.new(required_parameters)
    if @content.save
      @parent = params[:parent_id] ? Content.find(params[:parent_id]) : Content.root
      @content.move_to_child_of @parent

      flash[:notice] = 'Content was successfully created.'
      redirect_to admin_content_path(@content)
    else
      render :action => 'new'
    end
  end

  def edit
    @content = Content.find(params[:id])
    @contents = Content.get_content_list()
  end

  def update
    @content = Content.find(params[:id])
    @content.updated_by = current_user.login
    @contents = Content.get_content_list()
    if @content.update_attributes(required_parameters)
      unless params[:parent_id].blank?
        @parent = Content.find(params[:parent_id])
        @content.move_to_child_of @parent
      end
      flash[:notice] = 'Content was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end
  
  private

  def required_parameters
    params.require(:content).permit(:content, :url, :title)
  end

end
