class CarService
  def initialize(user, recommendations, params = {})
    @user = user
    @recommendations = recommendations
    @params = params
  end

  def find_cars
    preferred_brands = @user.preferred_brands.map(&:id).join(',')
    preferred_price_range = @user.preferred_price_range

    cars = Car.joins(:brand).includes(:brand).select('cars.*')
    car_ids = @recommendations.empty? ? '0' : @recommendations.map { |car| car['car_id'] }.join(',')

    label_case = <<-SQL
      CASE
      WHEN brand_id
        IN (#{preferred_brands}) and price between #{preferred_price_range.first} AND #{preferred_price_range.last}
        THEN 2
      WHEN brand_id
        IN (#{preferred_brands})
        THEN 1
      ELSE 0 END as label,
      CASE WHEN cars.id IN (#{car_ids}) THEN 1 ELSE 0 END as rank
    SQL
    cars = cars.select(ActiveRecord::Base::sanitize_sql(label_case))

    cars = cars.where('price > ?', @params[:price_min]) if @params[:price_min].present?
    cars = cars.where('price < ?', @params[:price_max]) if @params[:price_max].present?
    cars = cars.where('brands.name ILIKE ?', "%#{@params[:query]}%") if @params[:query].present?

    cars.order(label: :desc, rank: :desc, price: :asc).page(@params[:page])
  end
end
