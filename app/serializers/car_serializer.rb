class CarSerializer < ActiveModel::Serializer
  attributes :id, :brand, :price, :rank_score, :model, :label

  def brand
    {
      id: self.object.brand_id,
      name: self.object.brand.name
    }
  end

  def rank_score
    car_recommendation = @instance_options[:recommendations].detect { |recommendation| recommendation['car_id'] == self.object.id }

    return car_recommendation['rank_score'] if car_recommendation.present?

    nil
  end

  def label
    case self.object.label
    when 2
      "perfect_match"
    when 1
      "good_match"
    else
      nil
    end
  end
end
