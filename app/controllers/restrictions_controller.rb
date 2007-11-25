class RestrictionsController < ApplicationController
  # GET /restrictions
  # GET /restrictions.xml
  def index
    @restrictions = Restrictions.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @restrictions.to_xml }
    end
  end

  # GET /restrictions/1
  # GET /restrictions/1.xml
  def show
    @restrictions = Restrictions.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @restrictions.to_xml }
    end
  end

  # GET /restrictions/new
  def new
    @restrictions = Restrictions.new
  end

  # GET /restrictions/1;edit
  def edit
    @restrictions = Restrictions.find(params[:id])
  end

  # POST /restrictions
  # POST /restrictions.xml
  def create
    @restrictions = Restrictions.new(params[:restrictions])

    respond_to do |format|
      if @restrictions.save
        flash[:notice] = 'Restrictions was successfully created.'
        format.html { redirect_to restrictions_url(@restrictions) }
        format.xml  { head :created, :location => restrictions_url(@restrictions) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @restrictions.errors.to_xml }
      end
    end
  end

  # PUT /restrictions/1
  # PUT /restrictions/1.xml
  def update
    @restrictions = Restrictions.find(params[:id])

    respond_to do |format|
      if @restrictions.update_attributes(params[:restrictions])
        flash[:notice] = 'Restrictions was successfully updated.'
        format.html { redirect_to restrictions_url(@restrictions) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @restrictions.errors.to_xml }
      end
    end
  end

  # DELETE /restrictions/1
  # DELETE /restrictions/1.xml
  def destroy
    @restrictions = Restrictions.find(params[:id])
    @restrictions.destroy

    respond_to do |format|
      format.html { redirect_to restrictions_url }
      format.xml  { head :ok }
    end
  end
end
