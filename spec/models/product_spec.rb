require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:stock) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:state) }
  it { is_expected.to have_and_belong_to_many(:orders) }
end
