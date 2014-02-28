class AccessController < ApplicationController
  skip_before_filter  :authenticate_user!

  def denied;end

  def unavailable;end

end
