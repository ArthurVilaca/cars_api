require 'net/http'

class ExternalRecommendationService
  def initialize(user, params = {})
    @user = user
  end

  def recommended
    url = 'https://bravado-images-production.s3.amazonaws.com/recomended_cars.json?user_id=' + @user.id.to_s
    result = Rails.cache.fetch("#{@user.id}/recomended_cars", expires_in: 10.minutes) do
      Net::HTTP.get(URI.parse(url))
    end
    JSON.parse(result)
  end
end
