json.array! @polls do |poll|
    json.id poll.id
    json.subject poll.subject
    json.status poll.status
    json.options poll.poll_options.map {
        |o| o.slice(:id, :title, :ballots_count)
    }
end