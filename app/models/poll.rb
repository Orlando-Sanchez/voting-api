class Poll < ApplicationRecord
	has_many :poll_options
	has_many :votes
	belongs_to :user
	enum status: { open: 0, closed: 1 }, _prefix: true
	accepts_nested_attributes_for :poll_options
	validates :subject, presence: true, length: { minimum: 3 }
	validates :poll_options, presence: true, length: 2..5
end