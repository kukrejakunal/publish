class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery
  before_filter :authenticate_user!

  # Before filter to check if user a can access a resource using cancan
  # In case user can not access that resource then unauthorized action/custom handler is called
  #  Parameters:
  #  1. permission (Mandatory) - Permission name
  #  2. options (Optional) - Following options are supported:
  #       model: It corresponds to model field in Permission model
  #       handler: Custom Handler method name (this will be called in case of unauthorized requests)
  #       handler_params: Array of objects to be passed as arguments for custom handler
  def require_permission(permission,model=nil,options = {})
    handler = options[:handler] || :unauthorized
    handler_params = !options[:handler].nil?? Array(options[:handler_params]) : nil
    send(handler,*handler_params) unless user.can?(permission, model.present?? model : :all)
  end

  ## Default handler for unauthorized requests. Used by require_permission before filter
  ## Redirects to access denied page for http requests
  ## In case of XMLHttpRequest sends a "Access denied" message in form of json
  def unauthorized
    if request.xhr?
      message = {:message => "Access Denied"}
      render :json => message.to_json, status: 403
    else
      redirect_to global_path(:access_denied_path)
    end
  end

end
