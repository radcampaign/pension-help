class Admin::ContentController < ApplicationController
  uses_tiny_mce(:options => {:theme => 'advanced',
                             :browsers => %w{msie gecko},
                             :theme_advanced_toolbar_location => "top",
                             :theme_advanced_toolbar_align => "left",
                             :theme_advanced_resizing => true,
                             :theme_advanced_resize_horizontal => false,
                             :paste_auto_cleanup_on_paste => true,
                             :content_css => '/stylesheets/default.css',
                             :theme_advanced_styles => 'Red Header=redheader;Blue Header=blueheader',
                             :theme_advanced_buttons1 => %w{bold italic underline separator strikethrough justifyleft justifycenter justifyright justifyfull separator bullist numlist separator undo redo separator link unlink separator styleselect formatselect separator code},
                             :theme_advanced_buttons2 => [],
                             :theme_advanced_buttons3 => [],
                             :plugins => %w{contextmenu paste}},
                             :extended_valid_elements => %w{a[name|href|target|title|onclick] img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name] hr[class|width|size|noshade] font[face|size|color|style] span[class|align|style]},
                             :width => 680,
                :only => [:new, :edit, :show, :index])
  
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @content_pages, @contents = paginate :contents, :per_page => 10
  end

  def show
    @content = Content.find(params[:id])
  end

  def new
    @content = Content.new
  end

  def create
    @content = Content.new(params[:content])
    if @content.save
      flash[:notice] = 'Content was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @content = Content.find(params[:id])
  end

  def update
    @content = Content.find(params[:id])
    if @content.update_attributes(params[:content])
      flash[:notice] = 'Content was successfully updated.'
      redirect_to :action => 'show', :id => @content
    else
      render :action => 'edit'
    end
  end

  def destroy
    Content.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
