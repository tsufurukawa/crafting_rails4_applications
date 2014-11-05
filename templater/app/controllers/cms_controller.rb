class CmsController < ActionController::Base
  include ActionController::Rendering
  include AbstractController::Helpers
  prepend_view_path ::SqlTemplate::Resolver.instance

  def respond
    render template: params[:page]
  end
end