class PollRepresenter
  def initialize(poll)
    @poll = poll
  end

  def as_json
    {
      id: poll.id,
      subject: poll.subject,
      options: poll_options_titles
    }
  end

  def poll_options_titles
    poll.poll_options.map(&:title)
  end

  private

  attr_reader :poll
end