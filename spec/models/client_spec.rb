require 'rails_helper'

RSpec.describe Client, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:dni) }
  it { should validate_presence_of(:email) }
  it { is_expected.to have_many(:orders) }
end
