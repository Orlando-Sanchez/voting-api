class PollOption < ApplicationRecord
	belongs_to :poll
	validates :title, presence: true, length: { minimum: 1 }
end