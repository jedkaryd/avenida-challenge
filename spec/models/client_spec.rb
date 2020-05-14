require 'rails_helper'

RSpec.describe Client, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:dni) }
  it { should validate_presence_of(:email) }
  it { is_expected.to have_many(:orders) }

  describe 'validations' do
    subject { create(:client) }
    it { is_expected.to validate_uniqueness_of :email }
  end
end
