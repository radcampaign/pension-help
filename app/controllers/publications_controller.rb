class PublicationsController < ApplicationController
  # GET /publications
  # GET /publications.xml
  def index
    @publications = Publication.all

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @publications.to_xml }
    end
  end

  # GET /publications/1
  # GET /publications/1.xml
  def show
    @publication = Publication.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @publication.to_xml }
    end
  end

  # GET /publications/new
  def new
    @publication = Publication.new
  end

  # GET /publications/1;edit
  def edit
    @publication = Publication.find(params[:id])
  end

  # POST /publications
  # POST /publications.xml
  def create
    @publication = Publication.new(params[:publication])

    respond_to do |format|
      if @publication.save
        flash[:notice] = 'Publication was successfully created.'
        format.html { redirect_to publication_url(@publication) }
        format.xml  { head :created, :location => publication_url(@publication) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @publication.errors.to_xml }
      end
    end
  end

  # PUT /publications/1
  # PUT /publications/1.xml
  def update
    @publication = Publication.find(params[:id])

    respond_to do |format|
      if @publication.update_attributes(params[:publication])
        flash[:notice] = 'Publication was successfully updated.'
        format.html { redirect_to publication_url(@publication) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @publication.errors.to_xml }
      end
    end
  end

  # DELETE /publications/1
  # DELETE /publications/1.xml
  def destroy
    @publication = Publication.find(params[:id])
    @publication.destroy

    respond_to do |format|
      format.html { redirect_to publications_url }
      format.xml  { head :ok }
    end
  end
end
