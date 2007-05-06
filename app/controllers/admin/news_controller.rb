class Admin::NewsController < ApplicationController
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
                             :theme_advanced_styles => 'Red Header=redheader;Blue Header=blueheader',
                             :theme_advanced_buttons1 => %w{bold italic underline strikethrough separator justifyleft justifycenter justifyright separator indent outdent separator bullist numlist separator undo redo separator link unlink separator styleselect formatselect separator code},
                             :theme_advanced_buttons2 => [],
                             :theme_advanced_buttons3 => [],
                             :plugins => %w{contextmenu paste}},
                             :extended_valid_elements => %w{a[name|href|target|title|onclick] img[class|src|border=0|alt|title|hspace|vspace|width|height|align|name] hr[class|width|size|noshade] font[face|size|color|style] span[class|align|style]},
                :only => [:new, :edit])
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @news_pages, @news = paginate :news, :per_page => 10
  end

  def show
    @news = News.find(params[:id])
  end

  def new
    @news = News.new
  end

  def create
    @news = News.new(params[:news])
    if @news.save
      flash[:notice] = 'News was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @news = News.find(params[:id])
  end

  def update
    @news = News.find(params[:id])
    if @news.update_attributes(params[:news])
      flash[:notice] = 'News was successfully updated.'
      redirect_to :action => 'show', :id => @news
    else
      render :action => 'edit'
    end
  end

  def destroy
    News.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
