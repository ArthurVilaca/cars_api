class CarsController < ApplicationController
  before_action :validate_user, :recommendations

  def index
    cars = CarService.new(@user, @recommendations, allow_params).find_cars
    render json: cars, recommendations: @recommendations
  end

  protected

  def validate_user
    @user = User.find(allow_params[:user_id])
  end

  def allow_params
    params.permit(
      :user_id,
      :query,
      :price_min,
      :price_max,
      :page
    )
  end

  def recommendations
    @recommendations = ExternalRecommendationService.new(@user).recommended
  end
end
