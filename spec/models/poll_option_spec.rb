require 'rails_helper'

RSpec.describe PollOption, type: :model do
	it { is_expected.to belong_to(:poll) }

	it { is_expected.to validate_presence_of(:title) }
	it { is_expected.to validate_length_of(:title).is_at_least(1) }
end