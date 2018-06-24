class Api::ApiController < ActionController::API
  rescue_from PG::UniqueViolation, with: :already_exists
  rescue_from ActionController::RoutingError, with: :nothing_found
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private
  def internal_error(error)
    render json: { message: 'Exception!' }, status: 500
  end

  def not_found(exception)
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :not_found }
      format.any { render text: "Error: #{exception.message}", status: :not_found }
    end
  end

  def already_exists(error)
    render json: { message: 'Already exists!' }, status: 409
  end
end
