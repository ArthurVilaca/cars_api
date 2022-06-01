require 'rails_helper'

RSpec.describe CarService do
  let!(:user) { create(:user, :with_preferred_brands) }
  let(:params) { {} }
  let(:service) { described_class.new(user, [], params) }

  describe '#find_cars' do
    before do
      create_list(:car, 5)
    end

    context 'no query params' do
      it 'should search for the paginated cars' do
        expect(service.find_cars.to_a.count).to eq(5)
      end
    end

    context 'query by brand params' do
      let(:params) { { query: Car.last.brand.name } }
      it 'should search for the cars by brand' do
        expect(service.find_cars.to_a.count).to eq(1)
      end
    end

    context 'query by price params' do
      before do
        create(:car, price: 10)
      end

      context 'by max price' do
        let(:params) { { price_max: 2 } }
        it 'should search for the cars by max price' do
          expect(service.find_cars.to_a.count).to eq(5)
        end
      end

      context 'by min price' do
        let(:params) { { price_min: 2 } }
        it 'should search for the cars by max price' do
          expect(service.find_cars.to_a.count).to eq(1)
        end
      end
    end

    context 'pagination with order' do
      before do
        create_list(:car, 17)
        user.preferred_brands.each do |brand|
          create_list(:car, 2, brand: brand)
          create(:car, brand: brand, price: 1.5)
        end
      end

      context 'page 1' do
        let(:params) { { page: 1 } }

        it 'should search for the paginated cars' do
          cars = service.find_cars.to_a
          expect(cars.count).to eq(20)
          expect(cars.select { |car| car.label == 2 }.count).to eq(2)
          expect(cars.select { |car| car.label == 1 }.count).to eq(4)
        end
      end

      context 'page 2' do
        let(:params) { { page: 2 } }

        it 'should search for the paginated cars' do
          cars = service.find_cars.to_a
          expect(cars.count).to eq(8)
          expect(cars.select { |car| car.label == 2 }.count).to eq(0)
          expect(cars.select { |car| car.label == 1 }.count).to eq(0)
        end
      end
    end
  end

  describe '#rank_score_case_when_sql' do
    context 'when no recommendations' do
      it 'should search for the paginated cars' do
        expect(service.rank_score_case_when_sql).to eq('0 as rank')
      end
    end

    context 'with recommendations' do
      let(:service) { described_class.new(user, JSON.parse('[{"car_id": 1, "rank_score": 1}]'), params) }

      it 'should search for the paginated cars' do
        expect(service.rank_score_case_when_sql).to include('CASE WHEN cars.id = 1 THEN 1')
      end
    end
  end
end
