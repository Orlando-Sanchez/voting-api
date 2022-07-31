class ClosePollJob < ApplicationJob
    queue_as :default

    after_perform :ballots_count

    def perform(id)
        @poll = Poll.find(id)
        @poll.status_closed!
    end

    private

    def ballots_count
        poll_options = @poll.poll_options
        poll_options.each { |poll_option| 
            count = poll_option.ballots.count()

            poll_option.update_column(:ballots_count, count)
        }
    end
end