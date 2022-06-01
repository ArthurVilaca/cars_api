require 'rails_helper'

RSpec.describe CarsController do
  let!(:user) { create(:user) }

  describe '#index' do
    context 'when user_id exists' do
      subject { get :index, params: { user_id: 1 } }

      before do
        allow_any_instance_of(CarService).to receive(:find_cars).and_return([])
      end

      it 'should call the car service' do
        expect(subject).to have_http_status(:ok)
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
