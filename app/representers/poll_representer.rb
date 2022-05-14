class PollRepresenter
    def initialize(poll)
        @poll = poll
    end

    def as_json
        {
            id: poll.id,
            subject: poll.subject
        }
    end

    private
  
    attr_reader :poll
end