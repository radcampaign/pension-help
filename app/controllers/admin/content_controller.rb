class Admin::ContentController < ApplicationController
  before_filter :authenticate_user!, :authorized?
  
  def authorized?
    current_user.is_admin?
  end
  #
  # tinymce(:options => {:theme => 'advanced',
  #                            :browsers => %w{msie gecko safari opera},
  #                            :theme_advanced_styles => 'Offsite Link=offsite',
  #                            :theme_advanced_buttons1 => %w{bold italic underline strikethrough separator justifyleft justifycenter justifyright separator indent outdent separator bullist numlist separator undo redo separator link unlink anchor separator styleselect formatselect separator code ts_image},
  #                           :extended_valid_elements => %w{a[name|href|target|title|onclick|class|id] img[class|src|border=0|alt|title|hspace|vspace|width|height|align|name|usemap] hr[class|width|size|noshade] font[face|size|color|style] span[class|align|style] map[id|name] area[shape|coords|href|alt|target]},
  #                            :theme_advanced_buttons2 => [],
  #                            :theme_advanced_buttons3 => [],
  #                            :forced_root_block => 'p',
  #                            :plugins => %w{contextmenu paste safari}},
  #               :only => [:new, :edit])

  
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
    @content = Content.new(params[:content])
    if @content.save
      @parent = params[:parent_id] ? Content.find(params[:parent_id]) : Content.root
      @content.move_to_child_of @parent

      flash[:notice] = 'Content was successfully created.'
      redirect_to :action => 'list'
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
    if @content.update_attributes(params[:content])
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
  # def paginate_collection(collection, options = {})
  #   default_options = {:per_page => 10, :page => 1}
  #   options = default_options.merge options
  #
  #   pages = Paginator.new self, collection.size, options[:per_page], options[:page]
  #   first = pages.current.offset
  #   last = [first + options[:per_page], collection.size].min
  #   slice = collection[first...last]
  #   return [pages, slice]
  # end

end
