require 'rails_helper'

RSpec.describe Poll, type: :model do
	it { is_expected.to have_many(:votes) }
	it { is_expected.to have_many(:poll_options) }

	it { is_expected.to accept_nested_attributes_for(:poll_options) }

	it { is_expected.to validate_presence_of(:subject) }
	it { is_expected.to validate_length_of(:subject).is_at_least(3) }

	it { is_expected.to validate_presence_of(:poll_options) }

	it "is not valid if there aren't at least two poll options" do
		expect(FactoryBot.build(:poll, subject: 'First poll', poll_options_attributes: [{ title: 'first' }])).to_not be_valid
	end

	it "is not valid if there are more than five poll options" do
		expect(FactoryBot.build(:poll, subject: 'First poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }, { title: 'third' }, { title: 'fourth' }, { title: 'fifth' }, { title: 'sixth' }])).to_not be_valid
	end
end