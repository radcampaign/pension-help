class WarningController < ApplicationController

  def show
    session[:viewed_cookies_warning] = true
    unless params[:js_disabled].blank?
      @js_disabled = true
      #remember that user has seen warning message
      # session[:seen_js_disabled_warning] = true
    end

    unless params[:cookies_disabled].blank?
      #if cookies does not work breaks rails sessions(each request starts new session)
      @cookies_disabled = true
    end
  end
end
