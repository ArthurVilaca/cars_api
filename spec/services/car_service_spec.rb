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

    context 'pagination' do
      before do
        create_list(:car, 52)
      end

      context 'page 1' do
        let(:params) { { page: 1 } }

        it 'should search for the paginated cars' do
          expect(service.find_cars.to_a.count).to eq(20)
        end
      end

      context 'page 2' do
        let(:params) { { page: 2 } }

        it 'should search for the paginated cars' do
          expect(service.find_cars.to_a.count).to eq(20)
        end
      end

      context 'page 3' do
        let(:params) { { page: 3 } }

        it 'should search for the paginated cars' do
          expect(service.find_cars.to_a.count).to eq(17)
        end
      end
    end
  end
end
