class ClosePollJob < ApplicationJob
    queue_as :default

    def perform(id)
        poll = Poll.find(id)
        poll.status_closed!
    end
end