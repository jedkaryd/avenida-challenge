class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    render json: { error: 'record not found' }, status: :not_found
  end

  def bad_request(err)
    render json: { error: err }, status: :bad_request
  end
end
