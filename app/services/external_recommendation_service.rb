require 'net/http'

class ExternalRecommendationService
  RECOMENDED_CARS_URL = 'https://bravado-images-production.s3.amazonaws.com/recomended_cars.json'

  def initialize(user, params = {})
    @user = user
  end

  def recommended
    result = Rails.cache.fetch("#{@user.id}/recomended_cars", expires_in: 10.minutes) do
      Net::HTTP.get(URI.parse("#{RECOMENDED_CARS_URL}?user_id=#{@user.id.to_s}"))
    end
    JSON.parse(result)
  rescue Exception => e
    []
  end
end
