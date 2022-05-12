class PollsRepresenter
    def initialize(polls)
        @polls = polls
    end
  
    def as_json
        polls.map do |poll|
            {
                id: poll.id,
                subject: poll.subject,
            }
        end
    end
  
    private
  
    attr_reader :polls
end