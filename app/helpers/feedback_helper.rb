module FeedbackHelper

  def column_header_link_to label, params, options = {}
    link_to label, prepare_url_params(params,options)
  end

  private
  def prepare_url_params params, options
    url = Hash.new
    url[:order] = options[:order]
    url[:desc] = params[:order]==options[:order] && params[:desc].blank? ? true : nil
    url[:category] = params[:category] if params[:category]
    url[:resolved] = params[:resolved] if params[:resolved]
    url[:page] = (params[:page]) ? params[:page] : '1'
    return url
  end
end
