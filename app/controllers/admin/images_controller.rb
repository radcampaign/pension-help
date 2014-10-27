class Admin::ImagesController < ApplicationController
  before_filter :login_required

  def authorized?
    current_user.is_admin?
  end

  def index
    @images = Image.find(:all, :conditions => 'thumbnail is null') #get list of images here
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @image = Image.new(params[:image])
    respond_to do |format|
      if @image.save
        format.html
        format.js do
          responds_to_parent do
            render :update do |page|
              page << "ts_insert_image('#{@image.public_filename()}', '#{@image.filename}');"
            end
          end
        end
      else
        format.html
        format.js do
          responds_to_parent do
            render :update do |page|
              page.alert('sorry, error uploading image')
            end
          end
        end
      end
    end
  end
end
