require 'rails_helper'

RSpec.describe Poll do
  it { is_expected.to have_many(:poll_options) }

  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_length_of(:subject).is_at_least(3) }

  it { is_expected.to validate_presence_of(:poll_options) }
end