class Api::ApiController < ActionController::API
  rescue_from PG::UniqueViolation, with: :already_exists

  private
  def already_exists(error)
    render json: {message: error.message}, status: 409
  end
end
