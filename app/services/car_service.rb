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

    label_case = <<-SQL
      CASE
      WHEN brand_id
        IN (#{preferred_brands}) and price between #{preferred_price_range.first} AND #{preferred_price_range.last}
        THEN 2
      WHEN brand_id
        IN (#{preferred_brands})
        THEN 1
      ELSE 0 END as label
      #{rank_score_sql()}
    SQL
    cars = cars.select(ActiveRecord::Base::sanitize_sql(label_case))

    cars = cars.where('price > ?', @params[:price_min]) if @params[:price_min].present?
    cars = cars.where('price < ?', @params[:price_max]) if @params[:price_max].present?
    cars = cars.where('brands.name ILIKE ?', "%#{@params[:query]}%") if @params[:query].present?

    cars.order(label: :desc, rank: :desc, price: :asc).page(@params[:page])
  end

  def rank_score_sql
    return '' if @recommendations.empty?

    case_when = @recommendations.map do |recommendation|
      'WHEN cars.id = ' + recommendation['car_id'].to_s + ' THEN ' + recommendation['rank_score'].to_s
    end

    <<-SQL
      , CASE #{case_when.join(' ')}
      ELSE 0 END as rank
    SQL
  end
end
