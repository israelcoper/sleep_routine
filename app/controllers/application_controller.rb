class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def serialize(resource)
    result = if resource.respond_to?(:all)
      "#{resource.klass}Serializer".constantize.new(resource.all)
    else
      "#{resource.class}Serializer".constantize.new(resource)
    end

    result.serializable_hash.to_json
  end

  private

  def not_found
    render json: { error: "Not Found" }, status: :not_found
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
