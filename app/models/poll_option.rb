class PollOption < ApplicationRecord
	belongs_to :poll
	has_many :ballots
	validates :title, presence: true, length: { minimum: 1 }
end