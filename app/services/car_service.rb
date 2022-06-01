class CarService
  def initialize(user, params = {})
    @user = user
    @params = params
    @recommendations = ExternalRecommendationService.new(user).recommended
  end

  def find_cars
    preferred_brands = @user.preferred_brands.map(&:id).join(',')
    preferred_price_range = @user.preferred_price_range

    cars = Car.joins(:brand).select('cars.id, cars.price, cars.model, cars.brand_id, brands.name as brand_name')

    label_case = <<-SQL
      CASE
      WHEN brand_id IN (#{preferred_brands}) and price between #{preferred_price_range.first} AND #{preferred_price_range.end} THEN 2
      WHEN brand_id IN (#{preferred_brands}) THEN 1
      ELSE 0 END as label
    SQL
    cars = cars.select(label_case)

    car_ids = @recommendations.map { |car| car['car_id'] }.join(',')
    cars = cars.select("CASE WHEN cars.id IN (#{car_ids}) THEN 1 ELSE 0 END as rank")

    cars = cars.where('price > ?', @params[:price_min]) if @params[:price_min].present?
    cars = cars.where('price < ?', @params[:price_max]) if @params[:price_max].present?
    cars = cars.where('brands.name LIKE ?', "%#{@params[:query]}%") if @params[:query].present?

    cars.order(label: :desc, rank: :desc, price: :asc).page(@params[:page])
  end
end
