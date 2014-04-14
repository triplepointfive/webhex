class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    render file: 'application/application', layout: false
  end
end
