require 'rails_helper'

RSpec.describe Car do
  let(:car) { build(:car) }

  describe 'Validations' do
    context 'with valid params' do
      it 'is valid' do
        expect(car).to be_valid
      end
    end
  end
end