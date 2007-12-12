class Admin::ContentController < ApplicationController
  before_filter :login_required
  layout "admin"
  
  uses_tiny_mce(:options => {:theme => 'advanced',
                             :browsers => %w{msie gecko},
                             :theme_advanced_toolbar_location => "top",
                             :theme_advanced_toolbar_align => "left",
                             :paste_auto_cleanup_on_paste => true,
                             :content_css => '/stylesheets/styles.css',
                             :width => 631,
                             :height => 400,
                             :relative_urls => false,
                             :theme_advanced_styles => 'Offsite Link=offsite',
                             :theme_advanced_buttons1 => %w{bold italic underline strikethrough separator justifyleft justifycenter justifyright separator indent outdent separator bullist numlist separator undo redo separator link unlink separator styleselect formatselect separator code ts_image},
                              :extended_valid_elements => %w{a[name|href|target|title|onclick] img[class|src|border=0|alt|title|hspace|vspace|width|height|align|name|usemap] hr[class|width|size|noshade] font[face|size|color|style] span[class|align|style] map[id|name] area[shape|coords|href|alt|target]},
                             :theme_advanced_buttons2 => [],
                             :theme_advanced_buttons3 => [],
                             :forced_root_block => 'p',
                             :plugins => %w{contextmenu paste}},
                :only => [:new, :edit])
  
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @content_pages, @contents = paginate :contents, :per_page => 20, :order => 'url'
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
    @content.updated_by = current_user.login
    if @content.update_attributes(params[:content])
      flash[:notice] = 'Content was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

end
