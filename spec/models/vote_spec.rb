require 'rails_helper'

RSpec.describe Vote, type: :model do
	it { is_expected.to belong_to(:user) }
	it { is_expected.to belong_to(:poll) }
end