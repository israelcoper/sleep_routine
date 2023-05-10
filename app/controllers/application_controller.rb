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
end
