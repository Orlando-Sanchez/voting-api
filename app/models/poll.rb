class Poll < ApplicationRecord
    has_many :poll_options
    accepts_nested_attributes_for :poll_options
    validates :subject, presence: true, length: { minimum: 3 }
end
