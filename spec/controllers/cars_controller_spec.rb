require 'rails_helper'

RSpec.describe CarsController do
  let!(:user) { create(:user) }
  let!(:cars) { create_list(:car, 5) }

  describe '#index' do
    context 'when user_id exists' do
      subject { get :index, params: { user_id: 1 } }

      before do
        cars_response = cars.map do |car|
          car = car.attributes
          car['brand_name'] = 'test'
          car
        end
        allow_any_instance_of(CarService).to receive(:find_cars).and_return(cars_response)
      end

      it 'should call the car service' do
        expect(subject).to have_http_status(:ok)
        expect(JSON.parse(response.body).count).to eq(5)
      end
    end

    context 'when user_id does not exists' do
      subject { get :index }

      it 'should throw a error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
