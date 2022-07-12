require 'rails_helper'

RSpec.describe Ballot, type: :model do
	it { is_expected.to belong_to(:poll_option) }
end
