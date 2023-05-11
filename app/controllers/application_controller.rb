class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    @current_user
  end

  def serialize(resource)
    result = if resource.respond_to?(:all)
      options = {}

      options[:meta] = {
        previous_page: resource.prev_page,
        current_page: resource.current_page,
        next_page: resource.next_page,
        count: resource.size,
        total_count: resource.total_count
      }

      "#{resource.klass}Serializer".constantize.new(resource.all, options)
    else
      "#{resource.class}Serializer".constantize.new(resource)
    end

    result.serializable_hash.to_json
  end

  def page_number
    params.dig(:page, :number) || 1
  end

  def page_size
    params.dig(:page, :size) || 10
  end

  private

  def not_found
    render json: { error: "Not Found" }, status: :not_found
  end

  def user_not_authorized
    render json: { error: "Unauthorized" }, status: :unauthorized
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
